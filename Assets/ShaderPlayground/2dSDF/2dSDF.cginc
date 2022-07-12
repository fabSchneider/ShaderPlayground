// adapted from https://iquilezles.org/articles/distfunctions2d/

#ifndef SDF_POINTS
#define SDF_POINTS

#define MAX_POINT_COUNT 256

int _PointsCount = 0;
float2 _Points[MAX_POINT_COUNT];


float sdSegment(in float2 p, in float2 a, in float2 b)
{
    float2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

float sdPolygon(in float2 p)
{
    float d = dot(p - _Points[0], p - _Points[0]);
    float s = 1.0;
    for (int i = 0, j = _PointsCount - 1; i < _PointsCount; j = i, i++)
    {
        float2 e = _Points[j] - _Points[i];
        float2 w = p - _Points[i];
        float2 b = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
        d = min(d, dot(b, b));
        bool3 c = bool3(p.y >= _Points[i].y, p.y < _Points[j].y, e.x * w.y > e.y * w.x);
        if (all(c) || all(!c))
            s *= -1.0;
    }
    return s * sqrt(d);
}

void sdSegment_float(in float2 p, in float2 a, in float2 b, out float Out)
{
    Out = sdSegment(p, a, b);
}

void sdPolyline_float(in float2 p, out float Out)
{
    Out = 9999999;
    for (int i = 0; i < _PointsCount - 1; i++)
    {
        Out = min(Out, sdSegment(p, _Points[i], _Points[i + 1]));
    }
}

void sdPolygon_float(in float2 p, out float Out)
{
    Out = sdPolygon(p);
}
#endif