using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.behavior;

namespace ThinkSpatial.think_spatial.script.csharp.spawner
{
	public partial class EntitySpawner : Node3D
	{
		[Export] private int _entitiesToSpawn = 5;
		[Export] private PackedScene _entityToSpawn;

		[Export] private ShapeCast3D _shape;
		private Aabb _spawnArea;

		public override void _Ready()
		{
			base._Ready();

			if (_shape?.Shape is BoxShape3D boxShape)
			{
				var boxShapeSize = boxShape.Size * _shape.Transform.Basis.Scale;
				_spawnArea = new Aabb(GlobalPosition - boxShapeSize / 2.0f, boxShapeSize);
			}

			for (int i = 0; i < _entitiesToSpawn; ++i)
			{
				SpawnEntity();
			}
		}

		private void SpawnEntity()
		{
			EntityBehavior entityBehavior = _entityToSpawn.Instantiate<EntityBehavior>();

			entityBehavior.Entity.Death.AddListener(On_Death);

			float x = (float)GD.RandRange(_spawnArea.Position.X, _spawnArea.Position.X + _spawnArea.Size.X);
			float y = (float)GD.RandRange(_spawnArea.Position.Y, _spawnArea.Position.Y + _spawnArea.Size.Y);
			float z = (float)GD.RandRange(_spawnArea.Position.Z, _spawnArea.Position.Z + _spawnArea.Size.Z);

			AddChild(entityBehavior);

			entityBehavior.GlobalPosition = new Vector3(x, y, z);
		}

		private void On_Death()
		{
			SpawnEntity();
		}
	}
}
