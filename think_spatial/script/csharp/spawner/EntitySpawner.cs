using System.Collections.Generic;
using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.script.csharp.event_system.type;

namespace ThinkSpatial.think_spatial.script.csharp.spawner
{
	public partial class EntitySpawner : Node3D
	{
		[Export] public int EntitiesToSpawn = 3;
		[Export] protected bool SpawnEntitiesImmediately;
		[Export] protected PackedScene EntityToSpawn;
		[Export] protected ShapeCast3D Shape;

		protected readonly List<EntityBehavior> SpawnedEntities = new List<EntityBehavior>();
		protected Aabb SpawnArea;

		public readonly Message<EntityBehavior> EntityDeath = new Message<EntityBehavior>();
		public Message FinishedSpawningEntities = new Message();

		public override void _Ready()
		{
			base._Ready();

			if (Shape?.Shape is BoxShape3D boxShape)
			{
				Vector3 boxShapeSize = boxShape.Size * Shape.Transform.Basis.Scale;
				SpawnArea = new Aabb(GlobalPosition - boxShapeSize / 2.0f, boxShapeSize);
			}

			if (SpawnEntitiesImmediately)
			{
				SpawnEntities();
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

		public virtual void DestroyAllEntities()
		{
			for (int i = SpawnedEntities.Count - 1; i >= 0; i--)
			{
				SpawnedEntities[i]?.Death.Die();
			}

			SpawnedEntities.Clear();
		}

		public virtual EntityBehavior SpawnEntity()
		{
			EntityBehavior entity = EntityToSpawn.Instantiate<EntityBehavior>();
			SpawnedEntities.Add(entity);

			entity.Entity.Death.AddListener(() => On_Death(entity));

			float x = (float)GD.RandRange(SpawnArea.Position.X, SpawnArea.Position.X + SpawnArea.Size.X);
			float y = (float)GD.RandRange(SpawnArea.Position.Y, SpawnArea.Position.Y + SpawnArea.Size.Y);
			float z = (float)GD.RandRange(SpawnArea.Position.Z, SpawnArea.Position.Z + SpawnArea.Size.Z);

			AddChild(entity);

			entity.GlobalPosition = new Vector3(x, y, z);

			return entity;
		}

		protected virtual void On_Death(EntityBehavior entity)
		{
			if (SpawnedEntities.Remove(entity))
			{
				EntityDeath.Send(entity);
			}
		}
	}
}
