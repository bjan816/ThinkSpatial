using Godot;

namespace ThinkSpatial.think_spatial.scripts.csharp.math
{
	public static class Math
	{
		public static float SmoothStart(float x, float smoothness = 2)
		{
			return Mathf.Pow(x, smoothness);
		}

		public static float SmoothStop(float x, float smoothness = 2)
		{
			return 1 - Mathf.Pow((1 - x), smoothness);
		}

		public static float Mix(float a, float b, float aFactor)
		{
			return a * aFactor + b * (1 - aFactor);
		}

		public static float Lerp(float a, float b, float t)
		{
			return a + t * (b - a);
		}
	}
}