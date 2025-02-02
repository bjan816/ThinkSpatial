using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.framework;

namespace ThinkSpatial.think_spatial.scripts.csharp.ui_system
{
	public partial class FrontendNavigation : Node
	{
		public override void _Ready()
		{
			GetNode<Button>("Button_PlaySpatialPrecision").GrabFocus();
		}

		private void _on_button_play_spatial_precision_pressed()
		{
			GameController.Instance.SceneManager.SwitchScene("spatial_precision/spatial_precision", SceneManager.TransitionMode.Fade);
		}

		private void _on_button_play_spatial_memory_pressed()
		{
			GameController.Instance.SceneManager.SwitchScene("spatial_memory/spatial_memory", SceneManager.TransitionMode.Fade);
		}

		private void _on_button_quit_pressed()
		{
			GameController.Instance.QuitGame();
		}
	}
}
