using Godot;
using ThinkSpatial.think_spatial.script.csharp.framework;

namespace ThinkSpatial.think_spatial.script.csharp.camera
{
	public partial class MouseLook : Node3D
	{
		[Export(PropertyHint.Range, "0.1, 1.0")]
		private float _mouseSensitivity = 0.3f;

		[Export] private Node3D _cameraPivot;
		[Export] private Camera3D _camera;
		[Export] private RayCast3D _raycast;

		private Vector2 _mouseInput;

		public Camera3D Camera => _camera;
		public RayCast3D RayCast => _raycast;

		public override void _Ready()
		{
			base._Ready();

			GameController.Instance.CameraManager.MouseLook = this;

			Input.MouseMode = Input.MouseModeEnum.Captured;
		}

		public override void _Input(InputEvent @event)
		{
			base._Input(@event);

			if (GameController.Instance.LocalPlayer.MouseMovementBlocked.Is(true))
			{
				return;
			}

			if (Input.IsActionJustPressed("ui_cancel"))
			{
				Input.MouseMode = Input.MouseMode == Input.MouseModeEnum.Captured ? Input.MouseModeEnum.Captured : Input.MouseModeEnum.Visible;
			}

			if (Input.MouseMode != Input.MouseModeEnum.Captured)
			{
				return;
			}

			if (@event is InputEventMouseMotion mouseMotion)
			{
				_mouseInput = mouseMotion.Relative;

				UpdateLook();
			}
		}

		public void Reset()
		{
			RotationDegrees = new Vector3();
			_cameraPivot.RotationDegrees = new Vector3();
		}

		private void UpdateLook()
		{
			Vector3 newRotationDegrees = RotationDegrees;

			newRotationDegrees.Y -= _mouseInput.X * _mouseSensitivity;

			RotationDegrees = newRotationDegrees;

			newRotationDegrees = _cameraPivot.RotationDegrees;
			newRotationDegrees.X -= _mouseInput.Y * _mouseSensitivity;
			newRotationDegrees.X = Mathf.Clamp(newRotationDegrees.X, -90.0f, 90.0f);

			_cameraPivot.RotationDegrees = newRotationDegrees;
		}
	}
}