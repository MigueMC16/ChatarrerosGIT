using UnityEngine;

public class CrackSpreadController : MonoBehaviour
{
    [Header("Referencias")]
    public ParticleSystem targetParticleSystem; // arrástralo en el inspector
    public Material material;                  // arrastra el material con el Shader Graph
    public float spreadDuration = 1f;          // cuánto tarda en pasar de 0 a 1

    private float crackValue = 0f;
    private bool wasPlaying = false;

    void Start()
    {
        if (material != null)
        {
            material.SetFloat("_CrackSpread", 0f);
        }
    }

    void Update()
    {
        if (targetParticleSystem == null || material == null)
            return;

        bool isPlaying = targetParticleSystem.isPlaying;

        // Detecta reinicio
        if (isPlaying && !wasPlaying)
        {
            crackValue = 0f;
            material.SetFloat("_CrackSpread", 0f);
        }

        // Mientras esté reproduciéndose, avanza crackValue
        if (isPlaying)
        {
            crackValue += Time.deltaTime / spreadDuration;
            crackValue = Mathf.Clamp01(crackValue);
            material.SetFloat("_CrackSpread", crackValue);
        }

        wasPlaying = isPlaying;
    }
}
