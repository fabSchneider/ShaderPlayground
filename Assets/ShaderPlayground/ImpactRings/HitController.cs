using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Fab.ShaderPlayground
{

    [RequireComponent(typeof(Camera))]
    public class HitController : MonoBehaviour
    {
        private Camera cam;

        [SerializeField]
        private float cooldown = 0.1f;

        private WaitForSeconds cooldownWait;

        private void OnValidate()
        {
            cooldownWait = new WaitForSeconds(cooldown);
        }
        private void Start()
        {
            cam = GetComponent<Camera>();
            StartCoroutine(HitsCoroutine());
        }

        private IEnumerator HitsCoroutine()
        {
            while (true)
            {
                if (Input.GetMouseButton(0))
                {
                    Hit(cam.ScreenPointToRay(Input.mousePosition));
                    yield return cooldownWait;
                }
                else
                {
                    yield return null;
                }
            }
        }

        private void Hit(Ray ray)
        {
            if (Physics.Raycast(ray, out RaycastHit hit))
            {
                if (hit.collider.TryGetComponent(out ImpactRingsController impactController))
                {
                    impactController.AddHit(hit.point);
                }

            }
        }
    }
}