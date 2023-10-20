using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.scripts.csharp.framework;

namespace ThinkSpatial.think_spatial.scripts.csharp.first_person
{
	public partial class FirstPersonManager : PlayerBehavior
	{
		[Export] private FirstPersonWeapon _equippedWeapon;

		public override void _Ready()
		{
			base._Ready();

			Player.AttackOnce.SetTryer(OnTry_Attack);
		}

		private bool OnTry_Attack()
		{
			if (_equippedWeapon != null)
			{
				return _equippedWeapon.TryAttackOnce(GameController.Instance.CameraManager.MainCamera);
			}

			return false;
		}
	}
}
