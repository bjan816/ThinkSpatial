using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.event_system.behavior;
using ThinkSpatial.think_spatial.scripts.csharp.framework;
using ThinkSpatial.think_spatial.scripts.csharp.spawner;
using ThinkSpatial.think_spatial.scripts.csharp.ui_system;

namespace ThinkSpatial.think_spatial.scripts.csharp.game_mode
{
	public partial class SpatialPrecisionGameMode : Node3D
	{
		[Export] private EntitySpatialPrecisionSpawner _spatialPrecisionSpawner;
		[Export] private SpatialPrecisionUI _spatialPrecisionUI;

		[Export] private int _livesLeft = 3;
		private int _score;
		private bool _endGame;

		public override void _Ready()
		{
			base._Ready();

			_spatialPrecisionSpawner.FinishedSpawningEntities.AddListener(PreInGame);
			GameController.Instance.LocalPlayer.AttackMiss.AddListener(On_AttackMiss);

			_spatialPrecisionSpawner.EntityDeath.AddListener(On_EntityDeath);

			_spatialPrecisionUI.TitleAnimationFinished.AddListener(PreGame);
			_spatialPrecisionUI.CountdownAnimationFinished.AddListener(InGame);
			_spatialPrecisionUI.ScoreAnimationFinished.AddListener(PostGame);

			InitializeGame();
		}

		private void SanitizeVariables()
		{
			_livesLeft = 3;
			_score = 0;
			_endGame = false;

			UpdateUI();

			GameController.Instance.CameraManager.MouseLook.Reset();
		}

		private void On_AttackMiss()
		{
			if (_endGame)
			{
				return;
			}

			UpdateLife(-1);
		}

		private void On_EntityDeath(EntityBehavior entityBehavior)
		{
			if (_endGame)
			{
				return;
			}

			UpdateScore(entityBehavior, 1);

			_spatialPrecisionSpawner.SpawnEntity();
		}

		private void UpdateScore(EntityBehavior entityBehavior, int delta)
		{
			_score += delta;
		}

		private void UpdateLife(int delta)
		{
			if (delta == 0)
			{
				return;
			}

			_livesLeft += delta;

			UpdateUI();

			if (delta < 0)
			{
				_spatialPrecisionUI.PlayAnimation(SpatialMemoryUI.IncorrectAnimationName);
			}

			if (_livesLeft < 0)
			{
				EndGame();
			}
		}

		private void UpdateUI()
		{
			_spatialPrecisionUI.ScoreValueLabel.Text = _score.ToString();
			_spatialPrecisionUI.LivesLeftValueLabel.Text = Mathf.Max(0, _livesLeft + 1).ToString();
		}

		private void InitializeGame()
		{
			SanitizeVariables();

			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(true);
			GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(true);

			_spatialPrecisionUI.PlayAnimation(SpatialMemoryUI.TitleAnimationName);
		}

		private void PreGame()
		{
			_spatialPrecisionSpawner.SpawnEntities();
		}

		private void PreInGame()
		{
			_spatialPrecisionUI.PlayAnimation(SpatialMemoryUI.CountdownAnimationName);
		}

		private void InGame()
		{
			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(false);
			GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(false);
		}

		private void EndGame()
		{
			_endGame = true;

			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(true);
			GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(true);

			_spatialPrecisionSpawner.DestroyAllEntities();

			UpdateUI();

			_spatialPrecisionUI.PlayAnimation(SpatialMemoryUI.ScoreAnimationName);
		}

		private void PostGame()
		{
			InitializeGame();
		}
	}
}