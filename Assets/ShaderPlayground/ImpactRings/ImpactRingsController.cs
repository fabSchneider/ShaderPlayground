using UnityEngine;

namespace Fab.ShaderPlayground
{
    public class ImpactRingsController : MonoBehaviour
    {
        const int MAX_HITS_COUNT = 32;

        Renderer _renderer;
        MaterialPropertyBlock mpb;
        int hitsCount;
        Vector4[] hitObjectPositions = new Vector4[MAX_HITS_COUNT];
        float[] hitsDurations = new float[MAX_HITS_COUNT];
        float[] hitsTimers = new float[MAX_HITS_COUNT];
        float[] hitRadii = new float[MAX_HITS_COUNT];
        float[] hitsIntensities = new float[MAX_HITS_COUNT];

        [SerializeField]
        private float hitDuration = 1f;
        [SerializeField]
        private float hitRadius = 0.5f;

        void Awake()
        {
           

            _renderer = GetComponent<Renderer>();
            mpb = new MaterialPropertyBlock();
        }

        public void AddHit(Vector3 worldPosition)
        {
            int id = GetFreeHitId();
            hitObjectPositions[id] = transform.InverseTransformPoint(worldPosition);
            hitsDurations[id] = hitDuration;
            hitRadii[id] = hitRadius;
            hitsTimers[id] = 0;
        }
        int GetFreeHitId()
        {
            if (hitsCount < MAX_HITS_COUNT)
            {
                hitsCount++;
                return hitsCount - 1;
            }
            else
            {
                float minDuration = float.MaxValue;
                int minId = 0;
                for (int i = 0; i < MAX_HITS_COUNT; i++)
                {
                    if (hitsDurations[i] < minDuration)
                    {
                        minDuration = hitsDurations[i];
                        minId = i;
                    }
                }
                return minId;
            }
        }
        public void ClearAllHits()
        {
            hitsCount = 0;
            SendHitsToRenderer();
        }

        void Update()
        {
            UpdateHitsLifeTime();
            SendHitsToRenderer();
        }
        void UpdateHitsLifeTime()
        {
            for (int i = 0; i < hitsCount;)
            {
                hitsTimers[i] += Time.deltaTime;
                if (hitsTimers[i] > hitsDurations[i])
                {
                    SwapWithLast(i);
                }
                else
                {
                    i++;
                }
            }
        }
        void SwapWithLast(int id)
        {
            int idLast = hitsCount - 1;
            if (id != idLast)
            {
                hitObjectPositions[id] = hitObjectPositions[idLast];
                hitsDurations[id] = hitsDurations[idLast];
                hitsTimers[id] = hitsTimers[idLast];
                hitRadii[id] = hitRadii[idLast];
            }
            hitsCount--;
        }
        void SendHitsToRenderer()
        {
            _renderer.GetPropertyBlock(mpb);
            mpb.SetFloat("_HitsCount", hitsCount);
            mpb.SetFloatArray("_HitsRadius", hitRadii);
            for (int i = 0; i < hitsCount; i++)
            {
                if (hitsDurations[i] > 0f)
                {
                    hitsIntensities[i] = 1 - Mathf.Clamp01(hitsTimers[i] / hitsDurations[i]);
                }
            }
            mpb.SetVectorArray("_HitsObjectPosition", hitObjectPositions);
            mpb.SetFloatArray("_HitsIntensity", hitsIntensities);
            _renderer.SetPropertyBlock(mpb);
        }
    }
}