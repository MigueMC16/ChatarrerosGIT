#ifndef LIGHTNING_CUSTOM_INCLUDED
//Toda la librería
#define LIGHTNING_CUSTOM_INCLUDED

//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lightning.hsls"

//Las funciones del shader graph siempre tienen que ser un VOID
void GetMainLight(out half3 Color, out float3 Direction){

#if defined (SHADERGRAPH_PREVIEW)
Color=1;
Direction=float3(1, 1, -1); 

#else #if defined(SHADERGRAPH_PREVIEW)

Light light = GetMainLight(); 
Color = light.color;
Direction = light.direction;

#endif #if defined(SHADERGRAPH_PREVIEW)
}

#endif #ifndef (LIGHTNINT_CUSTOM_INCLUDED)