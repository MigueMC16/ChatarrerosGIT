Shader "Custom/PolarShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _TilingX ("Tiling X", Range(0,10)) = 1
        _TilingY ("Tiling Y", Range(0,10)) = 1
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
                // Centrar las coordenadas UV (ahora están entre -0.5 y 0.5)
                float2 centeredUV = (i.uv - 0.5) * float2(_TilingX, _TilingY);

                // Coordenadas polares
                float r = length(centeredUV); // sqrt(x^2 + y^2)
                float theta = atan2(centeredUV.y, centeredUV.x); // atan(y/x), con corrección de cuadrante

                // Normalizar theta de [-PI, PI] a [0, 1]
                float normTheta = (theta + 3.14159265) / (2.0 * 3.14159265);

                // Usamos r y theta para crear un patrón. Por ejemplo, anillos radiales.
                float rings = sin(r * 10.0); // más frecuencia = más anillos

                // Otra opción: bandas angulares
                float stripes = sin(normTheta * 20.0);

                // Combinamos ambos efectos
                float finalPattern = saturate((rings + stripes) * 0.5);

                return finalPattern * _MainColor;
            }
            ENDCG
        }
    }
}
