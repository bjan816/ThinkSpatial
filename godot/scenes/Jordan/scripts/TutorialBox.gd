extends Control

signal play

func _on_video_stream_player_finished():
	$CenterContainer/Panel/MarginContainer/VBoxContainer/VideoStreamPlayer.play()
	
func _on_button_pressed():
	$".".queue_free()
	play.emit()
