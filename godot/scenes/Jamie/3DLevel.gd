extends Node3D
class_name Game

@onready var final_menu : = $FinalMenu
@onready var player : = $Player
@onready var timer : = $Timer
@onready var map : = $Map1
@onready var scoreboard : = $Scoreboard

var hard_levels_dir = ["res://scenes/Jamie/world/Levels/Level1.tscn", "res://scenes/Jamie/world/Levels/Level2.tscn", "res://scenes/Jamie/world/Levels/Level3.tscn"]
var hard_levels = [load(hard_levels_dir[0]).instantiate(), load(hard_levels_dir[1]).instantiate(), load(hard_levels_dir[2]).instantiate()]
var hard_level_reset_pos = [Vector3(14, 1, 38), Vector3(-30, 1, 14), Vector3(30, 1, -2)]
var hard_level_reset_angle = [Vector3(0, 90, 0), Vector3(0, 270, 0), Vector3(0, 0, 0)]
var hard_level_test_pos = [Vector3(-26, 1, -38), Vector3(30, 1, -42), Vector3(-32.5, 1, 46)]

var play_time : = 0.0

var current_lev = 1

func _ready():
	self.add_child(hard_levels[current_lev - 1])
	reset_pos(current_lev)
	
	
func _process(delta):
	play_time += delta
	print('x = ' + str(player.global_transform.origin.x))
	print('z = ' + str(player.global_transform.origin.z))
	
	if Input.is_action_pressed('reset'):	
		reset_pos(current_lev)
		
	if Input.is_action_pressed('test'):	
		test_pos(current_lev)
		
	if check_goal_lev(current_lev):
		_on_level_completed()

func _on_level_completed():
	get_tree().paused = true
	final_menu.score = scoreboard.score
	final_menu.initialize(play_time)
	timer.hideTimer()
	scoreboard.hideScore()
	map.visible = false
	current_lev += 1

func _on_final_menu_retried():
	get_tree().reload_current_scene()

func _on_final_menu_next():
	self.add_child(hard_levels[current_lev - 1])
	self.remove_child(hard_levels[current_lev - 2])
	hard_levels[current_lev - 2].queue_free()
	reset_pos(current_lev)
	get_tree().paused = false
	

func check_goal_lev(lev):
	if lev == 1:
		if (player.global_transform.origin.x > -28 and player.global_transform.origin.x < -24) and (player.global_transform.origin.z > -36 and player.global_transform.origin.z < -32):
			return true
		else:
			return false
	elif lev == 2:
		if (player.global_transform.origin.x > 36 and player.global_transform.origin.x < 40) and (player.global_transform.origin.z > -44 and player.global_transform.origin.z < -40):
			return true
		else:
			return false
	elif lev == 3:
		if (player.global_transform.origin.x > -40 and player.global_transform.origin.x < -36) and (player.global_transform.origin.z > 44 and player.global_transform.origin.z < 48):
			return true
		else:
			return false

func reset_pos(lev):
	player.global_transform.origin = hard_level_reset_pos[lev - 1]
	player.rotation_degrees = hard_level_reset_angle[lev - 1]
	
func test_pos(lev):
	player.global_transform.origin = hard_level_test_pos[lev - 1]
