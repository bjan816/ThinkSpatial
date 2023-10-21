using System.Collections.Generic;
using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.type;
using ThinkSpatial.think_spatial.scripts.csharp.math;

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

		// New variables for grid and spacing
		private float spacing = 2;
		private int gridSize = 4;
		private int zPosition = -10;
		private List<Vector2> allPositions = new List<Vector2>();
		protected int nextPositionIndex = 0;

		public override void _Ready()
		{
			base._Ready();

			if (Shape?.Shape is BoxShape3D boxShape)
			{
				Vector3 boxShapeSize = boxShape.Size * Shape.Transform.Basis.Scale;
				SpawnArea = new Aabb(GlobalPosition - boxShapeSize / 2.0f, boxShapeSize);
			}

			// Generate all positions
			GenerateAllPositions();		
			// Shuffle positions once after generating them
			ShufflePositions();

			if (SpawnEntitiesImmediately)
			{
				SpawnEntities();
			}
		}

		// Generate grid positions
		private void GenerateAllPositions()
		{
			for (int y = 0; y < gridSize; ++y)
			{
				for (int x = -gridSize; x <= gridSize; ++x)
				{
					Vector2 position = new Vector2(x * spacing, y * spacing);
					allPositions.Add(position);
				}
			}
		}

		// Shuffle grid positions
		private void ShufflePositions()
		{
			int n = allPositions.Count;
			while (n > 1)
			{
				n--;
				int k = (int)GD.RandRange(0, n + 1);
				Vector2 value = allPositions[k];
				allPositions[k] = allPositions[n];
				allPositions[n] = value;
			}
		}

		public virtual void SpawnEntities()
		{
			for (int i = 0; i < EntitiesToSpawn; ++i)
			{
				SpawnEntity();
			}

			FinishedSpawningEntities.Send();
		}

		// Modified
		public virtual EntityBehavior SpawnEntity()
		{
			var soundEffect = GetNode<AudioStreamPlayer>("Bubble");
			soundEffect.Stream = GD.Load<AudioStream>("res://scenes/Borim/arts/audio/bubble.wav");
			soundEffect.Play();
			
			
			EntityBehavior entity = EntityToSpawn.Instantiate<EntityBehavior>();
			SpawnedEntities.Add(entity);

			entity.Entity.Death.AddListener(() => On_Death(entity));

			// Use the next position from the shuffled list
			Vector2 entityPosition = allPositions[nextPositionIndex];
			nextPositionIndex++; // Increment the counter for the next call
	
			float x = (float) entityPosition.X;
			float y = (float) entityPosition.Y;
			float z = (float) zPosition;
			
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
