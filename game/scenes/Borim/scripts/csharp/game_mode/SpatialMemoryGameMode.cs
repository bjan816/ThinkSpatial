using Godot;
using ThinkSpatial.think_spatial.scripts.csharp.framework;
using ThinkSpatial.think_spatial.scripts.csharp.spawner;
using ThinkSpatial.think_spatial.scripts.csharp.ui_system;

namespace ThinkSpatial.think_spatial.scripts.csharp.game_mode
{
	public partial class SpatialMemoryGameMode : Node3D
	{
		[Export] private EntitySpatialMemorySpawner _spatialMemorySpawner;
		[Export] private SpatialMemoryUI _spatialMemoryUI;

		private int _score;
		private int _numberOfRoundsPlayed;

		public override void _Ready()
		{
			
			var soundEffect = GetNode<AudioStreamPlayer>("Background");
			soundEffect.Stream = GD.Load<AudioStream>("res://think_spatial/arts/audio/background.ogg");
			soundEffect.Play();
			
			base._Ready();
			
			_spatialMemorySpawner.FinishedSpawningEntities.AddListener(PreInGame);
			_spatialMemorySpawner.ConsectiveDeath.AddListener(OnConsectiveDeath);
			_spatialMemorySpawner.SpatialMemoryResult.AddListener(EndGame);

			_spatialMemoryUI.TitleAnimationFinished.AddListener(PreGame);
			_spatialMemoryUI.CountdownAnimationFinished.AddListener(InGame);
			_spatialMemoryUI.CorrectAnimationFinished.AddListener(PostEndGame_Success);
			_spatialMemoryUI.IncorrectAnimationFinished.AddListener(PostEndGame_Fail);
			_spatialMemoryUI.ScoreAnimationFinished.AddListener(PostGame);

			InitializeGame();
		}

		private void OnConsectiveDeath()
		{
			++_score;

			_spatialMemoryUI.ScoreValueLabel.Text = _score.ToString();
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
			_spatialMemoryUI.PlayAnimation(SpatialMemoryUI.InGameAnimationName);

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

			_spatialMemoryUI.PlayAnimation(spatialMemoryResult == _spatialMemorySpawner.EntitiesToSpawn ? SpatialMemoryUI.CorrectAnimationName : SpatialMemoryUI.IncorrectAnimationName);
		}

		private void PostEndGame_Success()
		{
			++_numberOfRoundsPlayed;
			++_spatialMemorySpawner.EntitiesToSpawn;

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
