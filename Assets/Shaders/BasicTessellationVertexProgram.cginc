struct VSInput {
    float4 position : POSITION;
    float2 uv : TEXCOORD0;
};

struct VSOutput {
    float4 position : SV_Position;
    float2 uv : TEXCOORD0;
};

VSOutput vs(VSInput i) {
    VSOutput o;
    o.position = i.position;
    o.uv = i.uv;
    return o;
}
