using Godot;
using ThinkSpatial.think_spatial.script.csharp.camera;

namespace ThinkSpatial.think_spatial.script.csharp.framework
{
	public partial class GameController : Node
	{
		public static GameController Instance { get; private set; }

		[Export] private MouseLook _mouseLook;

		public Camera3D Camera => _mouseLook.Camera;

		public override void _Notification(int what)
		{
			base._Notification(what);

			Instance = this;
		}
	}
}