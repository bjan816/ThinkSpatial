﻿using Godot;

namespace ThinkSpatial.think_spatial.scripts.csharp.camera
{
	public partial class CameraManager : Node
	{
		public MouseLook MouseLook;

		public Camera3D MainCamera => MouseLook.Camera;
	}
}