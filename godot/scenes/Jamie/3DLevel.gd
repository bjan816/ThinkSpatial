extends Node3D
class_name Game

@onready var final_menu : = $FinalMenu
@onready var player : = $Player
@onready var timer : = $Timer
@onready var map : = $Map1
@onready var scoreboard : = $Scoreboard

var level1_scene = load("res://scenes/Jamie/world/Levels/Level1.tscn")
var play_time : = 0.0
var reset_position = Vector3(14.7119, 1.08666, 38.3666)
var simultaneous_scene = preload("res://scenes/Jamie/world/Levels/Level1.tscn").instantiate()
var free = false

func _ready():
	get_tree().root.add_child.call_deferred(simultaneous_scene)
	
func _process(delta):
	play_time += delta
	if Input.is_action_pressed('reset'):	
		player.global_transform.origin = reset_position
		player.rotation_degrees = Vector3(0, 90, 0)
	if simultaneous_scene.player_touched:
		_on_level_completed()

func _on_level_completed():
	get_tree().paused = true
	var total_play_time = play_time
	final_menu.initialize(total_play_time)
	timer.hideTimer()
	scoreboard.hideScore()
	map.visible = false

func _on_final_menu_retried():
	get_tree().reload_current_scene()
