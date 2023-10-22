using System.Collections.Generic;
using Godot;
using Math = ThinkSpatial.think_spatial.scripts.csharp.math.Math;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.type;

namespace ThinkSpatial.think_spatial.scripts.csharp.spawner
{
	public partial class EntitySpawner : Node3D
	{
		[Export] public int EntitiesToSpawn = 3;
		[Export] protected bool SpawnEntitiesImmediately = true;
		[Export] protected PackedScene EntityToSpawn;
		[Export] protected ShapeCast3D Shape;

		public int Level = 1;

		protected readonly List<EntityBehavior> SpawnedEntities = new List<EntityBehavior>();
		protected Aabb SpawnArea;

		public readonly Message<EntityBehavior> EntityDeath = new Message<EntityBehavior>();
		public Message FinishedSpawningEntities = new Message();

		private Vector2 _gridCenter = new Vector2I(0, 3);
		private Vector2I _gridSpacing = new Vector2I(2, 2);
		private Vector2I _gridSize = new Vector2I(4, 4);
		private int _zPosition = -10;
		private readonly List<Vector2> _spawnSlots = new List<Vector2>();

		private int _difficulty = 0;
		private int _nextSpawnSlot = 0;

		protected int EntityCapacity => _gridSize.X * _gridSize.Y;

		public override void _Ready()
		{
			base._Ready();

			if (Shape?.Shape is BoxShape3D boxShape)
			{
				Vector3 boxShapeSize = boxShape.Size * Shape.Transform.Basis.Scale;
				SpawnArea = new Aabb(GlobalPosition - boxShapeSize / 2.0f, boxShapeSize);
			}

			GenerateSpawnSlots();
			ShuffleSpawnSlots();

			if (SpawnEntitiesImmediately)
			{
				SpawnEntities();
			}
		}

		private void GenerateSpawnSlots()
		{
			_spawnSlots.Clear();

			Vector2I gridSizeHalf = _gridSize / 2;

			Vector2 topLeftPosition = _gridCenter;
			topLeftPosition.X -= gridSizeHalf.X * _gridSpacing.X;
			topLeftPosition.Y -= gridSizeHalf.Y * _gridSpacing.Y;

			Vector2 position = topLeftPosition;

			for (int y = 0; y < _gridSize.Y; ++y)
			{
				for (int x = 0; x < _gridSize.X; ++x)
				{
					position.X += _gridSpacing.X;

					_spawnSlots.Add(position);
				}

				position.X = _gridCenter.X - gridSizeHalf.X * _gridSpacing.X;
				position.Y += _gridSpacing.Y;
			}
		}

		private void ShuffleSpawnSlots()
		{
			int n = _spawnSlots.Count;
			while (n > 1)
			{
				n--;
				int k = GD.RandRange(0, n);
				(_spawnSlots[k], _spawnSlots[n]) = (_spawnSlots[n], _spawnSlots[k]);
			}
		}

		protected virtual void IncreaseDifficulty()
		{
			++_gridSize.X;
			_gridCenter.X -= 0.25f;

			// Every 3 difficulty, except the first
			if (_difficulty > 0 && _difficulty % 3 <= 0)
			{
				++_gridSize.Y;
				_gridCenter.Y += 1.0f;

				--_zPosition;
			}

			GenerateSpawnSlots();

			++_difficulty;
		}

		protected virtual void Randomize()
		{
			ShuffleSpawnSlots();

			_nextSpawnSlot = 0;
		}

		public virtual void SpawnEntities()
		{
			for (int i = 0; i < EntitiesToSpawn; ++i)
			{
				SpawnEntity();
			}

			FinishedSpawningEntities.Send();
		}

		public virtual EntityBehavior SpawnEntity()
		{
			var soundEffect = GetNode<AudioStreamPlayer>("Bubble");
			soundEffect.Stream = GD.Load<AudioStream>("res://scenes/Borim/arts/audio/bubble.wav");
			soundEffect.Play();

			EntityBehavior entity = EntityToSpawn.Instantiate<EntityBehavior>();
			SpawnedEntities.Add(entity);

			entity.Entity.Death.AddListener(() => On_Death(entity));


			Vector2 entityPosition = _spawnSlots[_nextSpawnSlot];
			++_nextSpawnSlot;

			float x = entityPosition.X;
			float y = entityPosition.Y;
			float z = _zPosition;

			AddChild(entity);

			// Setting the spawn position to the generated spawn location
			entity.GlobalPosition = new Vector3(x, y, z);

			// Generating the spawn scale
			{
				float minScale = 1.4f;
				float maxScale = 1.5f;

				float scale = GetScalingFactor(Level, minScale, maxScale);
				scale = (float)GD.RandRange(minScale, scale);

				entity.Scale = new Vector3(scale, scale, scale);
			}

			return entity;
		}

		protected virtual void On_Death(EntityBehavior entity)
		{
			if (SpawnedEntities.Remove(entity))
			{
				EntityDeath.Send(entity);
			}
		}

		public virtual void DestroyAllEntities()
		{
			for (int i = SpawnedEntities.Count - 1; i >= 0; i--)
			{
				SpawnedEntities[i]?.Death.Die();
			}

			SpawnedEntities.Clear();
		}

		private float GetScalingFactor(int level, float minScale, float maxScale)
		{
			// Use `1.0f -` and `1.0f +` to solve division by 0
			float normalized = 1.0f - (1.0f / (1.0f + level));

			float smoothStart = Math.SmoothStart(normalized, 5);
			float smoothStop = Math.SmoothStop(normalized, 2);
			float mix = Math.Mix(smoothStart, smoothStop, 0.95f);
			float lerp = Math.Lerp(minScale, maxScale, mix);

			return lerp;
		}
	}
}