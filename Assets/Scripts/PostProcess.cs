using System;
using UnityEngine;

public class PostProcess : MonoBehaviour
{
	[SerializeField] private Material _crtMaterial;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, _crtMaterial);
	}
}
