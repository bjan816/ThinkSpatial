extends Control

func _on_video_stream_player_finished():
	$CenterContainer/Panel/MarginContainer/VBoxContainer/VideoStreamPlayer.play()
	
func _on_button_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$".".queue_free()
	get_tree().change_scene_to_file("res://scenes/Jordan/scenes/BeginnerPuzzle.tscn")


func _on_button_2_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$".".queue_free()
	get_tree().change_scene_to_file("res://scenes/Jordan/scenes/Puzzle.tscn")
