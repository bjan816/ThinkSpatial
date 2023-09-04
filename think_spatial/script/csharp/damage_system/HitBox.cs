using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.script.csharp.event_system.event_handler;

namespace ThinkSpatial.think_spatial.script.csharp.damage_system
{
	public partial class HitBox : Node3D
	{
		[Export] private float _damageMultiplier = 1.0f;

		private bool _enabled;
		private EntityEventHandler _eventHandler;

		public override void _Ready()
		{
			base._Ready();

			if (GetParent() is EntityBehavior entityBehavior)
			{
				_eventHandler = entityBehavior.Entity;
			}

			_enabled = _eventHandler != null;
		}

		public void ReceiveDamage(HealthEventData eventData)
		{
			if (_enabled)
			{
				if (_eventHandler.Health.Get() > 0.0f)
				{
					eventData.Delta *= _damageMultiplier;
					_eventHandler.ChangeHealth.Try(eventData);
				}
			}
		}
	}
}