using Godot;
using ThinkSpatial.think_spatial.script.csharp.framework;

namespace ThinkSpatial.think_spatial.script.csharp.ui_system
{
	public partial class FrontendNavigation : Node
	{
		public override void _Ready()
		{
			GetNode<Button>("Button_Play").GrabFocus();
		}

		private void _on_button_play_pressed()
		{
			GameController.Instance.SceneManager.SwitchScene("level", SceneManager.TransitionMode.Fade);
		}

		private void _on_button_quit_pressed()
		{
			GameController.Instance.QuitGame();
		}
	}
}
