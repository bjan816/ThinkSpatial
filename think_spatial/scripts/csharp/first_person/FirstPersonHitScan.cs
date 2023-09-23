using Godot;
using Godot.Collections;
using ThinkSpatial.think_spatial.scripts.csharp.damage_system;
using ThinkSpatial.think_spatial.scripts.csharp.framework;

namespace ThinkSpatial.think_spatial.scripts.csharp.first_person
{
	public partial class FirstPersonHitScan : FirstPersonWeapon
	{
		[Export] private float _damagePerAttack = 1.0f;
		[Export] private float _attackDistance = 100.0f;
		[Export] private float _timeBetweenAttacks = 0.22f;
		[Export] private AnimationPlayer _animationPlayer;

		private float _nextTimeCanFire;

		public override bool TryAttackOnce(Camera3D camera)
		{
			if (Time.GetTicksMsec() < _nextTimeCanFire)
			{
				return false;
			}

			_nextTimeCanFire = Time.GetTicksMsec() + _timeBetweenAttacks;

			PerformAttack(camera);

			return true;
		}

		private void PerformAttack(Camera3D camera)
		{
			_animationPlayer.Play("Attack");

			PerformHitScan(camera);

			Attack.Send();
		}

		private void PerformHitScan(Camera3D camera)
		{
			var from = camera.GlobalPosition;
			var to = from - camera.GlobalTransform.Basis.Z * _attackDistance;

			PhysicsRayQueryParameters3D rayQuery = PhysicsRayQueryParameters3D.Create(from, to);

			Dictionary result = camera.GetWorld3D().DirectSpaceState.IntersectRay(rayQuery);

			bool attackMiss = false;

			if (result.Count > 0)
			{
				result.TryGetValue("collider", out var collider);
				HitBox hitBox = collider.As<HitBox>();

				if (hitBox != null)
				{
					HealthEventData eventData = new HealthEventData(-_damagePerAttack);
					hitBox.ReceiveDamage(eventData);
				}
				else
				{
					attackMiss = true;
				}
			}
			else
			{
				attackMiss = true;
			}

			if (attackMiss)
			{
				GameController.Instance.LocalPlayer.AttackMiss.Send();
			}
		}
	}
}
