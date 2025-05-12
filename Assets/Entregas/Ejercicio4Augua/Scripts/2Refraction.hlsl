#ifndef SCREEN_SPACE_REFRACTION_INCLUDED
#define SCREEN_SPACE_REFRACTION_INCLUDED

TEXTURE2D(_CameraOpaqueTexture);
SAMPLER(sampler_CameraOpaqueTexture);

// FLOAT version
void ApplyScreenRefraction_float(
    float2 screenUV,        // coordenadas en espacio de pantalla
    float2 objectUV,        // UVs del objeto para distorsión
    float strength,         // intensidad de refracción
    float4 normalSample,    // normal o ruido en objeto (ej: textura de olas)
    float4 tintColor,       // tinte y opacidad
    out float4 refractedColor
)
{
    float2 distortion = normalSample.xy * strength;

    // Desplazamos el UV de pantalla en base al ruido del objeto
    float2 distortedScreenUV = screenUV + distortion;

    // Sampleamos la textura de fondo (alineada a cámara)
    float4 sceneColor = SAMPLE_TEXTURE2D(_CameraOpaqueTexture, sampler_CameraOpaqueTexture, distortedScreenUV);

    // Mezclamos con tinte de color
    refractedColor = lerp(sceneColor, tintColor, tintColor.a);
}

// HALF version (Shader Graph compatibility)
void ApplyScreenRefraction_half(
    half2 screenUV,
    half2 objectUV,
    half strength,
    half4 normalSample,
    half4 tintColor,
    out half4 refractedColor
)
{
    half2 distortion = normalSample.xy * strength;
    half2 distortedScreenUV = screenUV + distortion;
    half4 sceneColor = SAMPLE_TEXTURE2D(_CameraOpaqueTexture, sampler_CameraOpaqueTexture, distortedScreenUV);
    refractedColor = lerp(sceneColor, tintColor, tintColor.a);
}

#endif

