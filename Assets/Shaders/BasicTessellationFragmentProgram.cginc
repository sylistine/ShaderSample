struct FSInput {
    float4 position : SV_Position;
    float2 uv : TEXCOORD0;
};

struct FSOutput {
    float4 color : SV_Target;
};

FSOutput fs(FSInput i) {
    FSOutput o;
    o.color = float4(1, 1, 1, 1);
    return o;
}
