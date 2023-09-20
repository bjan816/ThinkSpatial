extends Node3D
class_name Game

@onready var final_menu : = $FinalMenu
@onready var player : = $Player
@onready var timer : = $Timer
@onready var map : = $Map
@onready var scoreboard : = $Scoreboard

var play_time : = 0.0
var reset_position = Vector3(14.7119, 1.08666, 38.3666)


func _process(delta):
	play_time += delta
	if Input.is_action_pressed('reset'):
		player.global_transform.origin = reset_position
		player.rotation_degrees = Vector3(0, 90, 0)


func _on_level_1_level_completed():
	var total_play_time = play_time
	player.queue_free()
	final_menu.initialize(total_play_time)
	timer.hideTimer()
	scoreboard.hideScore()
	map.visible = false


func _on_final_menu_retried():
	get_tree().reload_current_scene()
