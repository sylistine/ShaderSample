struct PatchConstantInput {
    float tessFactor[3] : SV_TessFactor;
    float insideTessFactor : SV_InsideTessFactor;
};

struct DomainInput {
    float4 position : SV_Position;
};

struct DomainOutput {
    float4 position : SV_Position;
};

[domain("tri")]
DomainOutput ds(PatchConstantInput constInput, const OutputPatch<DomainInput, 3> i, float3 barycentricCoords : SV_DomainLocation) {
    DomainOutput o;
    
    float3 bU = i[0].position * barycentricCoords.x;
    float3 bV = i[1].position * barycentricCoords.y;
    float3 bW = i[2].position * barycentricCoords.z;

    float3 pos = bU + bV + bW;

    o.position = UnityObjectToClipPos(float4(pos.xyz, 1.0));

    return o;
}
