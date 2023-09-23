using System;
using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.type;
using ThinkSpatial.think_spatial.scripts.csharp.helper;

namespace ThinkSpatial.think_spatial.scripts.csharp.framework
{
	public partial class SceneManager : Node
	{
		public enum TransitionMode
		{
			None,
			Fade
		}

		enum TransitionColor
		{
			Black,
			Transparent
		}

		private SceneTree _tree;

		public readonly Message<string> SceneChanged = new Message<string>();
		public Node CurrentScene { get; set; }

		public override void _Ready()
		{
			_tree = GetTree();

			Window root = _tree.Root;
			CurrentScene = root.GetChild(root.GetChildCount() - 1);
		}

		public void SwitchScene(string sceneName, TransitionMode transitionMode = TransitionMode.None)
		{
			SceneChanged.Send(sceneName);

			switch (transitionMode)
			{
				case TransitionMode.None:
				{
					SwitchSceneDeferred(sceneName, transitionMode);
					break;
				}
				case TransitionMode.Fade:
				{
					FadeTo(TransitionColor.Black, 2, () => SwitchSceneDeferred(sceneName, transitionMode));
					break;
				}
			}
		}

		private void SwitchSceneDeferred(string sceneName, TransitionMode transitionMode)
		{
			CallDeferred(nameof(PerformSwitchScene), sceneName, Variant.From(transitionMode));
		}

		private void PerformSwitchScene(string sceneName, Variant transitionModeVariant)
		{
			CurrentScene.Free();

			PackedScene nextScene = (PackedScene)GD.Load($"res://think_spatial/scenes/{sceneName}.tscn");

			CurrentScene = nextScene.Instantiate();

			_tree.Root.AddChild(CurrentScene);
			_tree.CurrentScene = CurrentScene;

			TransitionMode transitionMode = transitionModeVariant.As<TransitionMode>();

			switch (transitionMode)
			{
				case TransitionMode.None:
				{
					break;
				}
				case TransitionMode.Fade:
				{
					FadeTo(TransitionColor.Transparent, 1);
					break;
				}
			}
		}

		private void FadeTo(TransitionColor transitionColor, double duration, Action finishedCallback = null)
		{
			CanvasLayer canvasLayer = new CanvasLayer
			{
				Layer = 10
			};

			CurrentScene.AddChild(canvasLayer);

			ColorRect colorRect = new ColorRect
			{
				Color = new Color(0, 0, 0, transitionColor == TransitionColor.Black ? 0 : 1),
				MouseFilter = Control.MouseFilterEnum.Ignore
			};

			colorRect.SetAnchorsAndOffsetsPreset(Control.LayoutPreset.FullRect);
			canvasLayer.AddChild(colorRect);

			GTween tween = new GTween(colorRect);
			tween.AnimateColor(new Color(0, 0, 0, transitionColor == TransitionColor.Black ? 1 : 0), duration);
			tween.Callback(() =>
			{
				canvasLayer.QueueFree();
				finishedCallback?.Invoke();
			});
		}
	}
}