using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Fab.ShaderPlayground
{
    [ExecuteInEditMode]
    public class SDFPointsController : MonoBehaviour
    {
        const int MAX_POINTS_COUNT = 256;

        Renderer _renderer;
        MaterialPropertyBlock mpb;
        Vector4[] positions = new Vector4[MAX_POINTS_COUNT];

        public Vector2[] points;

        void Awake()
        {
            _renderer = GetComponent<Renderer>();
            mpb = new MaterialPropertyBlock();
        }

        private void Update()
        {
            SendPointsToRenderer();
        }


        void SendPointsToRenderer()
        {
            _renderer.GetPropertyBlock(mpb);

            int count = Mathf.Min(points.Length, positions.Length);

            mpb.SetFloat("_PointsCount", count);

            for (int i = 0; i < count; i++)
            {
                positions[i] = points[i];
            }

            mpb.SetVectorArray("_Points", positions);
            _renderer.SetPropertyBlock(mpb);
        }
    }
}