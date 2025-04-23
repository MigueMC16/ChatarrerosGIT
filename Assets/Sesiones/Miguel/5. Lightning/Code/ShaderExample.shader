Shader "Custom/CodeExample"
{
    Properties
    {
        _BaseMap("Base Map", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags{"RenderType"="Opaque" "Queue"="Geometry" "RenderPipeLine"="UniversalPipeline"}

        LOD 100

        Pass
        { 
            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Input
            {
                float4 positionOS : POSITION;
                float2 texcoord : TEXCOORD0;
            };
            struct Varyings
            {
                float2 texcoord : TEXCOORD0;
                float4 positionHCS : SV_POSITION;
            };

            sampler2D _BaseMap;
            float4 _Color;

            Varyings Vertex(Input IN)
            {
                Varyings OUT;
                OUT.texcoord = IN.texcoord;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
                return OUT;
            }

            float4 Fragment(Varyings IN) : SV_Target
            {
                float4 col = tex2D(_BaseMap, IN.texcoord)*_Color; 
                return col;
            }
 
            ENDHLSL
        } 
    }
}