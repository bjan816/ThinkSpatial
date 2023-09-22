extends Node3D

var player_touched = false

func _on_goal_body_entered(body):
	if body is Player:
		player_touched = true
