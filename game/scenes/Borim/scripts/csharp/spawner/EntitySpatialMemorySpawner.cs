using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.type;
using ThinkSpatial.think_spatial.scripts.csharp.game_mode;

namespace ThinkSpatial.think_spatial.scripts.csharp.spawner
{
	public partial class EntitySpatialMemorySpawner : EntitySpawner
	{
		[Export] private float _spawnDelaySeconds = 1.0f;

		private int _numberOfSuccessfulConsectiveDeaths;

		public Message ConsectiveDeath = new Message();
		public Message<int> SpatialMemoryResult = new Message<int>();

		public override void _Ready()
		{
			SpawnEntitiesImmediately = false;

			base._Ready();
		}

		public override void SpawnEntities()
		{
			_numberOfSuccessfulConsectiveDeaths = 0;

			SpawnEntitiesWithDelay();
		}

		public override void DestroyAllEntities()
		{
			_numberOfSuccessfulConsectiveDeaths = -1;

			base.DestroyAllEntities();
		}

		private async void SpawnEntitiesWithDelay()
		{
			if (EntitiesToSpawn > EntityCapacity)
			{
				IncreaseDifficulty();
			}

			Randomize();

			float delay = SpatialMemoryDeveloperSettings.Enabled ? SpatialMemoryDeveloperSettings.SpawnDelay : _spawnDelaySeconds;

			for (int i = 0; i < EntitiesToSpawn; ++i)
			{
				SpawnEntity();

				await ToSignal(GetTree().CreateTimer(delay), "timeout");
			}

			FinishedSpawningEntities.Send();
		}

		protected override void On_Death(EntityBehavior entity)
		{
			if (_numberOfSuccessfulConsectiveDeaths == -1)
			{
				return;
			}

			if (SpawnedEntities.Count <= 0)
			{
				return;
			}

			if (SpatialMemoryDeveloperSettings.Enabled)
			{
				switch (SpatialMemoryDeveloperSettings.Win)
				{
					case SpatialMemoryDeveloperSettings.WinMode.Instant:
					{
						SpatialMemoryResult.Send(EntitiesToSpawn);
						DestroyAllEntities();
						break;
					}
					case SpatialMemoryDeveloperSettings.WinMode.AlwaysCorrect:
					{
						ConsectiveDeath.Send();

						++_numberOfSuccessfulConsectiveDeaths;

						if (_numberOfSuccessfulConsectiveDeaths >= EntitiesToSpawn)
						{
							SpatialMemoryResult.Send(EntitiesToSpawn);
						}

						break;
					}
				}

				base.On_Death(entity);

				return;
			}

			if (SpawnedEntities[0] == entity)
			{
				++_numberOfSuccessfulConsectiveDeaths;

				ConsectiveDeath.Send();

				if (_numberOfSuccessfulConsectiveDeaths >= EntitiesToSpawn)
				{
					SpatialMemoryResult.Send(_numberOfSuccessfulConsectiveDeaths);
				}
			}
			else
			{
				SpatialMemoryResult.Send(_numberOfSuccessfulConsectiveDeaths);
			}

			base.On_Death(entity);
		}
	}
}