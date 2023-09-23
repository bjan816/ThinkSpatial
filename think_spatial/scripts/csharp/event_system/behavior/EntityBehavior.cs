using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.event_handler;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.misc;

namespace ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior
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

		public EntityDeathHandler Death
		{
			get
			{
				if (_death == null)
				{
					_death = GetNodeOrNull<EntityDeathHandler>("EntityDeathHandler");
				}

				if (_death == null)
				{
					_death = GetNodeOrNull<EntityDeathHandler>("../EntityDeathHandler");
				}

				return _death;
			}
		}

		private EntityEventHandler _entity;
		private EntityDeathHandler _death;
	}
}