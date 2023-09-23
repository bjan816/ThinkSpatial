using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;

namespace ThinkSpatial.think_spatial.script.csharp.damage_system
{
	public partial class EntityVitals : EntityBehavior
	{
		public override void _Ready()
		{
			base._Ready();

			Entity.ChangeHealth.SetTryer(Try_ChangeHealth);
		}

		private bool Try_ChangeHealth(HealthEventData eventData)
		{
			if (Entity.Health.Get() <= 0.0f)
			{
				return false;
			}

			float newHealth = Entity.Health.Get() + eventData.Delta;

			Entity.Health.Set(newHealth);

			return true;
		}
	}
}