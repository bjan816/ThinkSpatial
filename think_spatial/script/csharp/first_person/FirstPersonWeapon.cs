using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.type;

namespace ThinkSpatial.think_spatial.script.csharp.first_person
{
	public partial class FirstPersonWeapon : FirstPersonObject
	{
		public Message Attack { get; private set; } = new Message();

		public virtual bool TryAttackOnce(Camera3D camera)
		{
			return false;
		}
	}
}