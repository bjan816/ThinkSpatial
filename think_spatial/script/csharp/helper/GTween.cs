using System;
using Godot;

namespace ThinkSpatial.think_spatial.script.csharp.helper
{
	public class GTween
	{
		private readonly Tween _tween;
		private readonly Node _node;

		public GTween(Node node)
		{
			_node = node;
			Kill();
			_tween = node.CreateTween();
		}

		public bool IsRunning() => _tween.IsRunning();

		public void Loop() => _tween.SetLoops();
		public void StopLooping() => _tween.SetLoops(1);

		public void Stop() => _tween.Stop();
		public void Pause() => _tween.Pause();
		public void Resume() => _tween.Play();

		public void Finished(Action callback) => _tween.Finished += callback;

		public PropertyTweener AnimateColor(Color color, double duration, bool modulateChildren = false, bool parallel = false)
		{
			if (_node is ColorRect)
			{
				return Animate("color", color, duration, parallel);
			}

			if (modulateChildren)
			{
				return Animate("modulate", color, duration, parallel);
			}

			return Animate("self_modulate", color, duration, parallel);
		}

		public PropertyTweener Animate(NodePath prop, Variant finalValue, double duration, bool parallel = false) =>
			parallel ? _tween.Parallel().TweenProperty(_node, prop, finalValue, duration) : _tween.TweenProperty(_node, prop, finalValue, duration);

		public CallbackTweener Callback(Action callback, bool parallel = false)
		{
			if (!parallel)
			{
				return _tween.TweenCallback(Callable.From(callback));
			}

			return _tween.Parallel().TweenCallback(Callable.From(callback));
		}

		public void Kill() => _tween?.Kill();
	}
}