using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class FadeControllerCanvasGroup : MonoBehaviour
{
    [Header("Referencia al CanvasGroup que cubre toda la pantalla (fondo negro)")]
    [SerializeField] private CanvasGroup panelFade;

    [Header("Director")]
    [SerializeField] private GameObject objetoDirector;
    [SerializeField] private GameObject objetoDirector2;
    [Header("Configuración de tiempos")]
    public float fadeDuration = 0.5f;
    public float blackHoldTime = 1.2f;

    private DirectorController controller;
    private DirectorController controller2;

    private void Awake()
    {
        objetoDirector.gameObject.SetActive(true);

        controller = objetoDirector.GetComponent<DirectorController>();
        controller2 = objetoDirector.GetComponent<DirectorController>();

        controller.StopDirector();
        controller2.StopDirector();

        if (panelFade == null)
        {
            Debug.LogError("FadeControllerCanvasGroup: falta asignar panelFade en el Inspector.");
            enabled = false;
            return;
        }

        // Aseguramos que, al principio, el panel esté activo y completamente opaco:
        panelFade.gameObject.SetActive(true);
        panelFade.alpha = 1f;
    }

    private void Start()
    {
        // Al iniciar la escena, hacemos el fade de negro (α=1) → transparente (α=0)
        StartCoroutine(Fade(1f, 0f, fadeDuration));
    }

    /// <summary>
    /// Llamar desde un botón en el Inspector para ejecutar: 
    /// 1) Fade transparente → negro
    /// 2) Esperar blackHoldTime
    /// 3) Fade negro → transparente
    /// </summary>
    public void FadeBlackThenBack()
    {
        panelFade.gameObject.SetActive(true);

        controller.StopDirector();
        controller2.StopDirector();

        StartCoroutine(FadeSequence());
    }

    private IEnumerator FadeSequence()
    {

        

        // 1) Fade de α=0 → α=1
        yield return StartCoroutine(Fade(0f, 1f, fadeDuration));

        // 2) Permanecer en negro durante blackHoldTime
        yield return new WaitForSeconds(blackHoldTime);

        // 3) Animacion
        yield return StartAnimationToFade();

        // 4) Fade de α=1 → α=0
        yield return StartCoroutine(Fade(1f, 0f, fadeDuration));

        panelFade.gameObject.SetActive(false);

        
    }

   private IEnumerator StartAnimationToFade()
    {
        yield return new WaitForSeconds(1.2f);

        controller.StartDirector();

    }


    /// <summary>
    /// Corutina que interpola panelFade.alpha desde startAlpha hasta endAlpha en 'duration' segundos.
    /// </summary>
    private IEnumerator Fade(float startAlpha, float endAlpha, float duration)
    {
        float elapsed = 0f;

        // Mientras no haya completado la duración:
        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.Clamp01(elapsed / duration);
            panelFade.alpha = Mathf.Lerp(startAlpha, endAlpha, t);
            yield return null;
        }
        // Aseguramos valor final exacto
        panelFade.alpha = endAlpha;

        // Si quedó completamente transparente (α=0), podemos desactivar el panel para ahorrar recursos
        if (Mathf.Approximately(endAlpha, 0f))
        {
            panelFade.gameObject.SetActive(false);
        }
    }
}