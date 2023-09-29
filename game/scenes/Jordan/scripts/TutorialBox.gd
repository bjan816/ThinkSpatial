extends Control

func _on_video_stream_player_finished():
	$CenterContainer/Panel/MarginContainer/VBoxContainer/VideoStreamPlayer.play()
	
func _on_button_pressed():
	$".".queue_free()
	get_tree().change_scene_to_file("res://scenes/Jordan/scenes/Puzzle.tscn")
