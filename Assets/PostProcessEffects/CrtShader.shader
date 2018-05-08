// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderSample/CrtEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PixelWidth("Pixel Width", Int) = 0
        _PixelHeight("Pixel Height", Int) = 0
        _PixelPitch("PixelPitch", Int) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // So named because it is less confusing a convention when writing tesselation shaders...
            struct vertexdata
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };

            vertexdata vert (appdata v)
            {
                vertexdata o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.uv);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }
            
            sampler2D _MainTex;
            uint _PixelWidth;
            uint _PixelHeight;
            uint _PixelPitch;

            float clamp01(float a) {
                return clamp(a, 0, 1);
            }
            float2 clamp01(float2 a) {
                return clamp(a, 0, 1);
            }
            float3 clamp01(float3 a) {
                return clamp(a, 0, 1);
            }
            float4 clamp01(float4 a) {
                return clamp(a, 0, 1);
            }

            float4 frag (vertexdata i) : SV_Target
            {
                float2 screenParams = _ScreenParams.xy / i.screenPos.w;
                float2 realPixelPos = i.screenPos.xy * screenParams;

                float2 pixelSize = float2(_PixelWidth, _PixelHeight);
                float2 pixelSpan = pixelSize + float2(_PixelPitch, _PixelPitch);
                float2 innerPixelPos = (int2)realPixelPos % (int2)pixelSpan;
                float2 realPixelsPerSubPixel = 0.333333 * pixelSize;

                float amountOfPixelRemaining = 1;
                float4 subPixelColor = float4(0, 0, 0, 0);

                float numberOfRealRedPixelsRemaining = max(realPixelsPerSubPixel.x - innerPixelPos.x, 0);
                float amountOfPixelToUse = min(numberOfRealRedPixelsRemaining, amountOfPixelRemaining);
                subPixelColor.r = amountOfPixelToUse / min(realPixelsPerSubPixel.x, 1);
                amountOfPixelRemaining -= amountOfPixelToUse;

                float numberOfRealGreenPixelsRemaining = max(realPixelsPerSubPixel.x - max(innerPixelPos.x - (realPixelsPerSubPixel.x), 0), 0);
                amountOfPixelToUse = min(numberOfRealGreenPixelsRemaining, amountOfPixelRemaining);
                subPixelColor.g = amountOfPixelToUse / min(realPixelsPerSubPixel.x, 1);
                amountOfPixelRemaining -= amountOfPixelToUse;

                float numberOfRealBluePixelsRemaining = max(realPixelsPerSubPixel.x - max(innerPixelPos.x - (realPixelsPerSubPixel.x * 2), 0), 0);
                amountOfPixelToUse = min(numberOfRealBluePixelsRemaining, amountOfPixelRemaining);
                subPixelColor.b = amountOfPixelToUse / min(realPixelsPerSubPixel.x, 1);
                amountOfPixelRemaining -= amountOfPixelToUse;

                float2 pitchTest = clamp01(innerPixelPos - pixelSize);
                subPixelColor *= 1 - max(pitchTest.x, pitchTest.y);

                // Integer divide to trim the remainder and grab just the top-left pixel, then normalize it again.
                float2 samplingPos = (float2)((int2)realPixelPos / (int2)pixelSpan) * pixelSpan / screenParams;
                float4 color = tex2D(_MainTex, samplingPos);
                color *= subPixelColor;
                return color;
            }
            ENDCG
        }
    }
}
