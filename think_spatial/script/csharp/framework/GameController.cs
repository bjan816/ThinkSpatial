using Godot;
using ThinkSpatial.think_spatial.script.csharp.camera;

namespace ThinkSpatial.think_spatial.script.csharp.framework
{
	public partial class GameController : Node
	{
		public static GameController Instance { get; private set; }

		[Export] private SceneManager _sceneManager;
		public MouseLook MouseLook;

		public SceneManager SceneManager => _sceneManager;
		public Camera3D Camera => MouseLook.Camera;

		public override void _Ready()
		{
			base._Ready();

			Instance = this;
		}

		public void QuitGame()
		{
			GetTree().Quit();
		}
	}
}
