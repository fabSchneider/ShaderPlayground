#ifndef POINT_CELLS
#define POINT_CELLS

#define MAX_POINT_COUNT 32

int _PointsCount = 0;
float2 _Points[MAX_POINT_COUNT];

void CalculateCells_float(float2 uv, out float Out)
{
    Out = 9999999;
    for (int i = 0; i < _PointsCount; i++)
    {
        float dist = length(uv - _Points[i]);
        Out = min(Out, dist);
    }
}
#endif