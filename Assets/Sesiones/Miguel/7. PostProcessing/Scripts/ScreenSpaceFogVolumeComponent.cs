using UnityEngine;
using UnityEngine.Rendering;

[VolumeComponentMenu("Custom/Screen Space Fog")]

public class ScreenSpaceFogVolumeComponent : VolumeComponent
{
    public ClampedFloatParameter intensity = new ClampedFloatParameter(1f, 0f, 1f);
    public ColorParameter fogColor = new ColorParameter(Color.white); 
    public Vector2Parameter fogParams = new Vector2Parameter(Vector2.right);
}
