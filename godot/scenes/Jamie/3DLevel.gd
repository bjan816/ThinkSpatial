extends Node3D
class_name Game

@onready var final_menu : = $FinalMenu
@onready var player : = $Player
@onready var timer : = $Timer
@onready var map : = $Map1
@onready var scoreboard : = $Scoreboard

var levels = ["res://scenes/Jamie/world/Levels/Level1.tscn", "res://scenes/Jamie/world/Levels/Level2.tscn"]
var level1 = load(levels[0]).instantiate()
var level2 = load(levels[1]).instantiate()

var play_time : = 0.0
var reset_position = Vector3(14.7119, 1.08666, 38.3666)
var free = false

func _ready():
	get_tree().root.add_child.call_deferred(level1)
	
func _process(delta):
	play_time += delta
	if Input.is_action_pressed('reset'):	
		player.global_transform.origin = reset_position
		player.rotation_degrees = Vector3(0, 90, 0)
	if level1.player_touched:
		_on_level_completed()

func _on_level_completed():
	get_tree().paused = true
	final_menu.score = scoreboard.score
	final_menu.initialize(play_time)
	timer.hideTimer()
	scoreboard.hideScore()
	map.visible = false

func _on_final_menu_retried():
	get_tree().reload_current_scene()

func _on_final_menu_next():
	get_node("/root").remove_child(level1)
	get_tree().root.add_child.call_deferred(level2)
