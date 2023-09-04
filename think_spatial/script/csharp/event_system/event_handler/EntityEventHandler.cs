using Godot;
using ThinkSpatial.think_spatial.script.csharp.damage_system;
using ThinkSpatial.think_spatial.script.csharp.event_system.type;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.event_handler
{
	public partial class EntityEventHandler : Node
	{
		public readonly Value<float> Health = new Value<float>(1.0f);
		public readonly Attempt<HealthEventData> ChangeHealth = new Attempt<HealthEventData>();

		public Message Death = new Message();
	}
}
