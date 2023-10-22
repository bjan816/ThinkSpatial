using ThinkSpatial.think_spatial.scripts.csharp.event_system.event_handler;

namespace ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior
{
	public partial class PlayerBehavior : EntityBehavior
	{
		public PlayerEventHandler Player
		{
			get
			{
				if (_player == null)
				{
					_player = GetNodeOrNull<PlayerEventHandler>("PlayerEventHandler");
				}

				if (_player == null)
				{
					_player = GetNodeOrNull<PlayerEventHandler>("../PlayerEventHandler");
				}

				return _player;
			}
		}

		private PlayerEventHandler _player;
	}
}
