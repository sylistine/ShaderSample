struct HullInput {
    float4 position : POSITION;
};

struct PatchConstantOutput {
    float tessFactor[3] : SV_TessFactor;
    float insideTessFactor : SV_InsideTessFactor;
};

struct HullOutput {
    float4 position : SV_Position;
};

float _TessFactor;

PatchConstantOutput PatchConstFunc(InputPatch<HullInput, 3> i) {
    PatchConstantOutput o;
    o.tessFactor[0] = _TessFactor;
    o.tessFactor[1] = _TessFactor;
    o.tessFactor[2] = _TessFactor;
    o.insideTessFactor = _TessFactor;
    return o;
}

[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[patchconstantfunc("PatchConstFunc")]
[outputcontrolpoints(3)]
HullOutput hs(InputPatch<HullInput, 3> i, uint ocpid : SV_OutputControlPointID) {
    HullOutput o;
    o.position = float4(i[ocpid].position.xyz, 1);
    return o;
}
