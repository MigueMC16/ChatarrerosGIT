#ifndef DISPLACEMENT_WAVES_INCLUDED
#define DISPLACEMENT_WAVES_INCLUDED

void ApplyDiagonalDisplacement_float(float3 position, float time, float frequency, float amplitude, out float3 displaced)
{
    float wave = sin((position.x + position.z) * frequency + time);
    displaced = position;
    displaced.y += wave * amplitude;
}

#endif
