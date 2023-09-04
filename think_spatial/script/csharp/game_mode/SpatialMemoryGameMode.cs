using Godot;
using ThinkSpatial.think_spatial.script.csharp.framework;
using ThinkSpatial.think_spatial.script.csharp.spawner;
using ThinkSpatial.think_spatial.script.csharp.ui_system;

namespace ThinkSpatial.think_spatial.script.csharp.game_mode
{
	public partial class SpatialMemoryGameMode : Node3D
	{
		[Export] private EntitySpatialMemorySpawner _spatialMemorySpawner;
		[Export] private SpatialMemoryUI _spatialMemoryUI;

		private int _score;
		private int _numberOfRoundsPlayed;

		public override void _Ready()
		{
			base._Ready();

			_spatialMemorySpawner.FinishedSpawningEntities.AddListener(PreInGame);
			_spatialMemorySpawner.SpatialMemoryResult.AddListener(EndGame);

			_spatialMemoryUI.TitleAnimationFinished.AddListener(PreGame);
			_spatialMemoryUI.CountdownAnimationFinished.AddListener(InGame);
			_spatialMemoryUI.CorrectAnimationFinished.AddListener(PostEndGame_Success);
			_spatialMemoryUI.IncorrectAnimationFinished.AddListener(PostEndGame_Fail);
			_spatialMemoryUI.ScoreAnimationFinished.AddListener(PostGame);

			InitializeGame();
		}

		private void SanitizeVariables()
		{
			_score = 0;
			_numberOfRoundsPlayed = 0;

			_spatialMemoryUI.ScoreValueLabel.Text = _score.ToString();

			GameController.Instance.CameraManager.MouseLook.Reset();
		}

		private void InitializeGame()
		{
			SanitizeVariables();

			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(true);
			GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(true);
			_spatialMemoryUI.PlayAnimation(SpatialMemoryUI.TitleAnimationName);
		}

		private void PreGame()
		{
			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(true);
			GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(_numberOfRoundsPlayed == 0);

			_spatialMemorySpawner.SpawnEntities();

			_spatialMemoryUI.PlayAnimation(SpatialMemoryUI.WaitingAnimationName);
		}

		private void PreInGame()
		{
			if (_numberOfRoundsPlayed == 0)
			{
				_spatialMemoryUI.PlayAnimation(SpatialMemoryUI.CountdownAnimationName);
			}
			else
			{
				_spatialMemoryUI.PlayAnimation(SpatialMemoryUI.HideAnimationName);
				InGame();
			}
		}

		private void InGame()
		{
			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(false);
			GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(false);
		}

		private void EndGame(int spatialMemoryResult)
		{
			if (spatialMemoryResult != _spatialMemorySpawner.EntitiesToSpawn)
			{
				GameController.Instance.LocalPlayer.MouseInputBlocked.Set(true);
				GameController.Instance.LocalPlayer.MouseMovementBlocked.Set(true);
			}

			_score += spatialMemoryResult;

			_spatialMemoryUI.ScoreValueLabel.Text = _score.ToString();
			_spatialMemoryUI.PlayAnimation(spatialMemoryResult == _spatialMemorySpawner.EntitiesToSpawn ? SpatialMemoryUI.CorrectAnimationName : SpatialMemoryUI.IncorrectAnimationName);
		}

		private void PostEndGame_Success()
		{
			++_numberOfRoundsPlayed;

			PreGame();
		}

		private void PostEndGame_Fail()
		{
			GameController.Instance.LocalPlayer.MouseInputBlocked.Set(true);

			_spatialMemorySpawner.DestroyAllEntities();

			_spatialMemoryUI.PlayAnimation(SpatialMemoryUI.ScoreAnimationName);
		}


		private void PostGame()
		{
			InitializeGame();
		}
	}
}
