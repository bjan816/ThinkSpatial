using Godot;
using ThinkSpatial.think_spatial.script.csharp.camera;

namespace ThinkSpatial.think_spatial.script.csharp.framework
{
	public partial class GameController : Node
	{
		public static GameController Instance { get; private set; }

		[Export] private SceneManager _sceneManager;
		[Export] private CameraManager _cameraManager;

		public SceneManager SceneManager => _sceneManager;
		public CameraManager CameraManager => _cameraManager;

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
