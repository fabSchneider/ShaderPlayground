#ifndef IMPACT_HITS
#define IMPACT_HITS

#define MAX_IMPACT_HITS_COUNT 32

int _HitsCount = 0;
float _HitsRadius[MAX_IMPACT_HITS_COUNT];
float3 _HitsObjectPosition[MAX_IMPACT_HITS_COUNT];
float _HitsIntensity[MAX_IMPACT_HITS_COUNT];

float DrawRing(float border, float intensity, float radius, float dist)
{
    float currentRadius = lerp(0, radius, 1 - intensity);//expand radius over time 
    return intensity * (1 - smoothstep(currentRadius, currentRadius + border, dist) - (1 - smoothstep(currentRadius - border, currentRadius, dist)));
}
void CalculateHitsFactor_float(float3 objectPosition, float3 objectNormal, float alpha, float border, out float factor, out float3 normal)
{
    factor = 0;
    for (int i = 0; i < _HitsCount; i++)
    {
        float3 hitVec = objectPosition - _HitsObjectPosition[i];
        float distanceToHit = length(hitVec);

        float f = DrawRing(border, _HitsIntensity[i], _HitsRadius[i], distanceToHit);
        normal += hitVec * f;
        factor += f * alpha;
    }
    factor = saturate(factor);
    //normal /= _HitsCount;
}
#endif