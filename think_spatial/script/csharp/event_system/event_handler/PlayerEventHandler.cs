using ThinkSpatial.think_spatial.script.csharp.event_system.type;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.event_handler
{
	public partial class PlayerEventHandler : EntityEventHandler
	{
		public readonly Attempt AttackOnce = new Attempt();
	}
}