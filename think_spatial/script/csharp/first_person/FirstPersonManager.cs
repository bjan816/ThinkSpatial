using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.script.csharp.framework;

namespace ThinkSpatial.think_spatial.script.csharp.first_person
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
