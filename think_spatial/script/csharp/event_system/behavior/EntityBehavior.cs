using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.event_handler;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.behavior
{
	public partial class EntityBehavior : Node3D
	{
		public EntityEventHandler Entity
		{
			get
			{
				if (_entity == null)
				{
					_entity = GetNodeOrNull<EntityEventHandler>("EntityEventHandler");
				}

				if (_entity == null)
				{
					_entity = GetNodeOrNull<EntityEventHandler>("../EntityEventHandler");
				}

				return _entity;
			}
		}

		private EntityEventHandler _entity;
	}
}