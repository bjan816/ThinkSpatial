﻿using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.misc
{
	public partial class EntityDeathHandler : EntityBehavior
	{
		public override void _Ready()
		{
			base._Ready();

			Entity.Health.AddChangeListener(OnChange_Health);
		}

		private void OnChange_Health()
		{
			if (Entity.Health.Get() <= 0.0f)
			{
				PerformDeath();
			}
		}

		private void PerformDeath()
		{
			Entity.Death.Send();

			GetParent().QueueFree();
		}
	}
}