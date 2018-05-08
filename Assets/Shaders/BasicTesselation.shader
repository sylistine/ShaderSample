Shader "Custom/BasicTesselation"
{
    Properties {
        _TessFactor( "Tessellation Factor", Range( 1, 64 ) ) = 2
    }

    SubShader {
        pass {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            
            #pragma vertex vs
            #pragma hull hs
            #pragma domain ds
            #pragma fragment fs

            #include "BasicTessellationVertexProgram.cginc"
            #include "BasicTessellationHullProgram.cginc"
            #include "BasicTessellationDomainProgram.cginc"
            #include "BasicTessellationFragmentProgram.cginc"


            ENDCG
        }
    }

    FallBack "Diffuse"
}
