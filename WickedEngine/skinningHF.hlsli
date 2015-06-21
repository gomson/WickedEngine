#include "skinningDEF.h"

#ifdef USE_GPU_SKINNING
#define SKINNING_ON

typedef matrix<float,4,4> bonetype;

cbuffer boneBuffer:register(b1){
	bonetype pose[MAXBONECOUNT];
	bonetype prev[MAXBONECOUNT];
}

inline void Skinning(inout float4 pos, inout float4 posPrev, inout float3 inNor, inout float4 inBon, inout float4 inWei)
{
	[branch]if(inWei.x || inWei.y || inWei.z || inWei.w){
		bonetype sump=0, sumpPrev=0;
		float sumw = 0.0f;
		inWei=normalize(inWei);
		for(uint i=0;i<4;i++){
			sumw += inWei[i];
			sump += pose[(uint)inBon[i]] * inWei[i];
			sumpPrev += prev[(uint)inBon[i]] * inWei[i];
		}
		sump/=sumw;
		sumpPrev/=sumw;
		pos = mul(pos,sump);
		posPrev = mul(posPrev,sumpPrev);
		inNor = mul(inNor,(float3x3)sump);
	}
}
inline void Skinning(inout float4 pos, inout float3 inNor, inout float4 inBon, inout float4 inWei)
{
	[branch]if(inWei.x || inWei.y || inWei.z || inWei.w){
		bonetype sump=0;
		float sumw = 0.0f;
		inWei=normalize(inWei);
		for(uint i=0;i<4;i++){
			sumw += inWei[i];
			sump += pose[(uint)inBon[i]] * inWei[i];
		}
		sump/=sumw;
		pos = mul(pos,sump);
		inNor = mul(inNor,(float3x3)sump);
	}
}
inline void Skinning(inout float4 pos, inout float4 inBon, inout float4 inWei)
{
	[branch]if(inWei.x || inWei.y || inWei.z || inWei.w){
		bonetype sump=0;
		float sumw = 0.0f;
		inWei=normalize(inWei);
		for(uint i=0;i<4;i++){
			sumw += inWei[i];
			sump += pose[(uint)inBon[i]] * inWei[i];
		}
		sump/=sumw;
		pos = mul(pos,sump);
	}
}

#endif