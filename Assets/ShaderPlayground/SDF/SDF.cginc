#ifndef DISTANCE_FIELD
#define DISTANCE_FIELD

int Width;
int Height;
RWTexture2D<float4> Source;
RWTexture2D<float4> Result;
int Step;

StructuredBuffer<float3> Colors;

uint2 WrapIndex(uint2 i) {
	return uint2(i.x, i.y);
}

void GetMinDistancePoint(float2 curPos, float3 tarInfo, inout float4 minInfo)
{
	// z channel is seed ID
	if (tarInfo.z > 0) {
		float2 v = abs(curPos - tarInfo.xy);
		//wrap around
		v = float2(min(v.x, Width - v.x), min(v.y, Height - v.y));
		float distance = dot(v, v);
		if (distance < minInfo.w) {
			minInfo = float4(tarInfo, distance);
		}
	}
}

[numthreads(8, 8, 1)]
void InitMask(uint3 id : SV_DispatchThreadID)
{
	float4 src = Source[id.xy];
	Source[id.xy] = float4(id.xy, src.x, 1);
}

[numthreads(8, 8, 1)]
void InitMask_Invert(uint3 id : SV_DispatchThreadID)
{
	float4 src = Source[id.xy];
	Source[id.xy] = float4(id.xy, 1 - src.x, 1);
}

void DistanceField_float(UnityTexture2D mask, float2 uv, out float dist)
{
	float4 texel = mask.texelSize;
	int stepAmount = log2(max(texel.z, texel.w));

	float4 res;
	for (int i = 0; i < stepAmount; i++)
	{
		// seed position,seed ID and distance with seed
		float4 minInfo = float4(0, 0, 0, 999999);
		GetMinDistancePoint(uv, Source[id.xy].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(-Step, -Step))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(-Step, Step))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(-Step, 0))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv+ uint2(0, -Step))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(0, Step))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(Step, -Step))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(Step, 0))].xyz, minInfo);
		GetMinDistancePoint(uv, Source[WrapIndex(uv + uint2(Step, Step))].xyz, minInfo);
		res = minInfo;
	}

	dist = 1 - exp(-sqrt(res.w) * 0.01);
}

// void FillDistanceTransform(uint3 id : SV_DispatchThreadID)
// {
// 	float4 info = Source[id.xy];
// 	float intensity = 1 - exp(-sqrt(info.w) * 0.01);
// 	Result[id.xy] = float4(intensity, intensity, intensity, 1);
// }

// void FillVoronoiDiagram(uint3 id : SV_DispatchThreadID)
// {
// 	float4 info = Source[id.xy];
// 	if (info.w < 10) {
// 		Result[id.xy] = float4(1, 0, 0, 1);
// 	}
// 	else {
// 		uint seedID = info.z;
// 		Result[id.xy] = float4(Colors[max(seedID - 1, 0)], 1);
// 	}
// }