using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class TerrainHeighmapExtractor : EditorWindow
{
    [SerializeField]
    private TerrainData terrain;

    [MenuItem("Tools/Terrain height map extractor")]
    public static void Init()
    {
        var window = GetWindow<TerrainHeighmapExtractor>();
        window.Show();
    }

    private void OnGUI()
    {
        SerializedObject so = new SerializedObject(this);
        EditorGUILayout.ObjectField(so.FindProperty(nameof(terrain)));
        so.ApplyModifiedProperties();

        using (new EditorGUI.DisabledGroupScope(terrain == null))
        {
            if(GUILayout.Button("Extract"))
                ExtractHeightmap();
        };
    }

    private void ExtractHeightmap()
    {
        terrain.SyncHeightmap();
        RenderTexture copy = new RenderTexture(terrain.heightmapTexture);
        copy.Create();
        string path = EditorUtility.SaveFilePanelInProject("Save heightmap", "heigthmap", "renderTexture", string.Empty);
        if (!string.IsNullOrEmpty(path))
        {
            AssetDatabase.CreateAsset(copy, path);
            AssetDatabase.SaveAssets();
        }
    }
}
