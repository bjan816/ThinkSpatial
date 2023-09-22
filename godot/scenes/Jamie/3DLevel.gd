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
var level

var play_time : = 0.0
var reset_position = Vector3(14.7119, 1.08666, 38.3666)
var free = false

var test = level1

var current = 1

func _ready():
	self.add_child(level1)
	
	
func _process(delta):
	play_time += delta
	
	if Input.is_action_pressed('reset'):	
		player.global_transform.origin = reset_position
		player.rotation_degrees = Vector3(0, 90, 0)
	if (player.global_transform.origin.x > 12.4 and player.global_transform.origin.x < 15.6) and (player.global_transform.origin.z > 44.3 and player.global_transform.origin.z < 47.6):
		_on_level_completed()
		player.global_transform.origin = reset_position
		player.rotation_degrees = Vector3(0, 90, 0)

func _on_level_completed():
	get_tree().paused = true
	final_menu.score = scoreboard.score
	final_menu.initialize(play_time)
	timer.hideTimer()
	scoreboard.hideScore()
	map.visible = false
	
	current += 1

func _on_final_menu_retried():
	get_tree().reload_current_scene()

func _on_final_menu_next():
	self.add_child(level2)
	self.remove_child(level1)
	level1.queue_free()
	test = level2
	level2.player_touched = false
	get_tree().paused = false
	
	print("p")
