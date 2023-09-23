using Godot;
using ThinkSpatial.think_spatial.script.csharp.event_system.type;

namespace ThinkSpatial.think_spatial.script.csharp.ui_system
{
	public partial class SpatialPrecisionUI : Control
	{
		[Export] public AnimationPlayer AnimationPlayer;
		[Export] public Label ScoreValueLabel;
		[Export] public Label LivesLeftValueLabel;

		public static readonly string TitleAnimationName = "Title";
		public static readonly string CountdownAnimationName = "Countdown";
		public static readonly string IncorrectAnimationName = "Incorrect";
		public static readonly string ScoreAnimationName = "Score";
		public static readonly string HideAnimationName = "Hide";

		public Message TitleAnimationFinished = new Message();
		public Message CountdownAnimationFinished = new Message();
		public Message IncorrectAnimationFinished = new Message();
		public Message ScoreAnimationFinished = new Message();

		public override void _Ready()
		{
			base._Ready();

			AnimationPlayer.AnimationFinished += AnimationPlayerOnAnimationFinished;
		}

		public void PlayAnimation(string animationName)
		{
			AnimationPlayer.Play(animationName);
		}

		public void StopAnimation(bool keepState = false)
		{
			AnimationPlayer.Stop(keepState);
		}

		private void AnimationPlayerOnAnimationFinished(StringName animationName)
		{
			if (animationName == TitleAnimationName)
			{
				TitleAnimationFinished.Send();
			}
			else if (animationName == CountdownAnimationName)
			{
				CountdownAnimationFinished.Send();
			}
			else if (animationName == IncorrectAnimationName)
			{
				IncorrectAnimationFinished.Send();
			}
			else if (animationName == ScoreAnimationName)
			{
				ScoreAnimationFinished.Send();
			}
		}
	}
}