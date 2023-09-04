using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.script.csharp.framework;

namespace ThinkSpatial.think_spatial.script.csharp.first_person
{
	public partial class FirstPersonManager : PlayerBehavior
	{
		private FirstPersonWeapon _equippedWeapon = new FirstPersonHitScan();

		public override void _Ready()
		{
			base._Ready();

			Player.AttackOnce.SetTryer(OnTry_Attack);
		}

		private bool OnTry_Attack()
		{
			return _equippedWeapon.TryAttackOnce(GameController.Instance.Camera);
		}
	}
}