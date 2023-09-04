using ThinkSpatial.think_spatial.script.csharp.event_system.type;
using ThinkSpatial.think_spatial.script.csharp.framework;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.event_handler
{
	public partial class PlayerEventHandler : EntityEventHandler
	{
		public readonly Value<bool> MouseInputBlocked = new Value<bool>(false);
		public readonly Value<bool> MouseMovementBlocked = new Value<bool>(false);

		public readonly Attempt AttackOnce = new Attempt();
		public readonly Message AttackMiss = new Message();

		public override void _Ready()
		{
			base._Ready();

			GameController.Instance.LocalPlayer = this;
		}
	}
}
