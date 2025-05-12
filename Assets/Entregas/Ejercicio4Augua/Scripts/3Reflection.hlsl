#ifndef CUSTOM_CUBEMAP_REFLECTION_INCLUDED
#define CUSTOM_CUBEMAP_REFLECTION_INCLUDED

TEXTURECUBE(_ReflectionCubemap);
SAMPLER(sampler_ReflectionCubemap);

// Función para Shader Graph: toma la dirección de luz y el color como entradas.
void CubemapReflection_float(
    float3 WorldNormal,
    float3 ViewDirection,
    float4 TintColor,        // RGB: color del tinte, A: intensidad del tinte
    float Smoothness,        // Valor entre 0 y 1: qué tan brillante es el highlight
    float3 MainLightDirection, // Dirección de la luz (input desde Shader Graph)
    float3 MainLightColor,    // Color de la luz (input desde Shader Graph)
    out float4 OutColor
)
{
    WorldNormal = normalize(WorldNormal);
    ViewDirection = normalize(ViewDirection);

    // Reflejo principal del cubemap
    float3 reflectedDir = reflect(-ViewDirection, WorldNormal);
    float4 cubemapColor = SAMPLE_TEXTURECUBE(_ReflectionCubemap, sampler_ReflectionCubemap, reflectedDir);

    // === Highlight especular ===
    float3 lightDir = normalize(MainLightDirection);
    float3 halfway = normalize(lightDir + ViewDirection);
    
    // Fresnel-Schlick aproximado: más brillante si el ángulo entre normal y halfway es pequeño
    float spec = pow(saturate(dot(WorldNormal, halfway)), 1.0 / saturate(Smoothness + 0.001));

    // Control de intensidad y color del highlight
    float3 specularHighlight = MainLightColor * spec;

    // Resultado final: cubemap + highlight + tinte
    float3 finalColor = lerp(cubemapColor.rgb, TintColor.rgb, TintColor.a) + specularHighlight;
    OutColor = float4(finalColor, 1.0);
}

// Función HALF (menor precisión)
void CubemapReflection_half(
    half3 WorldNormal,
    half3 ViewDirection,
    half4 TintColor,
    half Smoothness,
    half3 MainLightDirection,  // Dirección de la luz (input desde Shader Graph)
    half3 MainLightColor,      // Color de la luz (input desde Shader Graph)
    out half4 OutColor
)
{
    WorldNormal = normalize(WorldNormal);
    ViewDirection = normalize(ViewDirection);

    half3 reflectedDir = reflect(-ViewDirection, WorldNormal);
    half4 cubemapColor = SAMPLE_TEXTURECUBE(_ReflectionCubemap, sampler_ReflectionCubemap, reflectedDir);

    half3 lightDir = normalize(MainLightDirection);
    half3 halfway = normalize(lightDir + ViewDirection);
    half spec = pow(saturate(dot(WorldNormal, halfway)), 1.0 / saturate(Smoothness + 0.001));
    half3 specularHighlight = MainLightColor * spec;

    half3 finalColor = lerp(cubemapColor.rgb, TintColor.rgb, TintColor.a) + specularHighlight;
    OutColor = half4(finalColor, 1.0);
}

#endif // CUSTOM_CUBEMAP_REFLECTION_INCLUDED
