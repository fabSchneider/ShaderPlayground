
void Blur_float(UnityTexture2D tex, float2 uv, float samples, float lod, out float3 blur)
{
    int _lod = lod;
    float2 scale = tex.texelSize.xy * 4;
    float4 O =  (float4)0;
    int sLOD = 1 << _lod;
    int _samples = max(2, floor(samples));
    float sigma = _samples * 0.25;
    int s = _samples/sLOD;  
    for (int i = 0; i < s*s; i++)
    {
        float2 d = float2(i%(uint)s, i/(uint)s) * float(sLOD) - (float)_samples/2.;
        float2 t = d;
        O += exp(-0.5* dot(t/=sigma,t) ) / ( 6.28 * sigma*sigma ) * tex2Dlod( tex, float4(uv + scale * d, 0, _lod));
    }
    blur = O / O.a;
}