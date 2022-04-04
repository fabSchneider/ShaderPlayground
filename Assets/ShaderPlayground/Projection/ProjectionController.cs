using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectionController : MonoBehaviour
{
    private int terrainLayerMask;
    public Transform projectionVolume;

    void Start()
    {
        terrainLayerMask = LayerMask.GetMask("Terrain");
    }

    void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out RaycastHit hit, float.PositiveInfinity, terrainLayerMask))
        {
            projectionVolume.gameObject.SetActive(true);
            projectionVolume.position = hit.point;
        }
        else
        {
            projectionVolume.gameObject.SetActive(false);
        }
    }
}
