Shader "Custom/PolarTextureShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _TilingX ("Tiling R (rings)", Range(0,10)) = 1
        _TilingY ("Tiling Theta (twists)", Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainColor;
            float _TilingX;
            float _TilingY;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 centeredUV = i.uv - 0.5;

                float r = length(centeredUV);
                float theta = atan2(centeredUV.y, centeredUV.x); // [-PI, PI]

                float normTheta = (theta + 3.14159265) / (2.0 * 3.14159265);

                // Aplica tiling en coordenadas polares
                float2 polarUV = float2(r * _TilingX, normTheta * _TilingY);

                // frac() para repetir entre 0 y 1
                fixed4 texColor = tex2D(_MainTex, frac(polarUV));

                return texColor * _MainColor;
            }
            ENDCG
        }
    }
}
