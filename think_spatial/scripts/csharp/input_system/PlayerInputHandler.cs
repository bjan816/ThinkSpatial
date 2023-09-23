using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior;

namespace ThinkSpatial.think_spatial.scripts.csharp.input_system
{
	public partial class PlayerInputHandler : PlayerBehavior
	{
		public override void _Input(InputEvent @event)
		{
			base._Input(@event);

			if (Player.MouseInputBlocked.Is(true))
			{
				return;
			}

			if (Input.IsActionJustPressed("Attack"))
			{
				Player.AttackOnce.Try();
			}
		}
	}
}
