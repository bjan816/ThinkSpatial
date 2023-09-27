extends Node3D
class_name Game

#Time, 5 minutes = 1000

@onready var final_menu : = $FinalMenu
@onready var player : = $Player
@onready var timer : = $Timer
@onready var scoreboard : = $Scoreboard

@onready var hard_map1 : = $Hard1
@onready var hard_map2 : = $Hard2
@onready var hard_map3 : = $Hard3

var hard_levels_dir = ["res://scenes/Jamie/world/Levels/Level1.tscn", "res://scenes/Jamie/world/Levels/Level2.tscn", "res://scenes/Jamie/world/Levels/Level3.tscn"]
var hard_levels = [load(hard_levels_dir[0]).instantiate(), load(hard_levels_dir[1]).instantiate(), load(hard_levels_dir[2]).instantiate()]
var hard_level_reset_pos = [Vector3(14, 1, 38), Vector3(-30, 1, 14), Vector3(30, 1, -2)]
var hard_level_reset_angle = [Vector3(0, 90, 0), Vector3(0, 270, 0), Vector3(0, 0, 0)]
var hard_level_test_pos = [Vector3(-26, 1, -38), Vector3(30, 1, -42), Vector3(-32.5, 1, 46)]

var play_time : = 0.0

var current_lev = 1

#Player's Score per level
var lev1Score = 0
var lev2Score = 0
var lev3Score = 0

#Player's Distance Variables
var playerStartPosition = Vector3(0, 0, 0)
var playerTotalDistance = 0.0
var currentPos = 0.0
var distanceMoved = 0.0


func _ready():
	self.add_child(hard_levels[current_lev - 1])	
	reset_pos(current_lev)
	map_visible(current_lev)
	playerStartPosition = player.global_transform.origin
	
	
func _process(delta):
	
	#Calculates player's movement
	currentPos = player.global_transform.origin
	distanceMoved = currentPos.distance_to(playerStartPosition)
	playerTotalDistance += distanceMoved
	playerStartPosition = currentPos
	print(playerTotalDistance)
	
	#Calculates play time
	play_time += delta
	#print('x = ' + str(player.global_transform.origin.x))
	#print('z = ' + str(player.global_transform.origin.z))
	
	if Input.is_action_pressed('reset'):	
		reset_pos(current_lev)
		playerTotalDistance = 0
		
	if Input.is_action_pressed('test'):	
		test_pos(current_lev)
		
	if check_goal_lev(current_lev):
		_on_level_completed()

func _on_level_completed():
	print("Total distance moved: ", playerTotalDistance)
	get_tree().paused = true
	final_menu.score = scoreboard.score + distanceScore(current_lev)
	final_menu.initialize(play_time)
	timer.hideTimer()
	scoreboard.hideScore()
	map_visible(current_lev)

func _on_final_menu_retried():
	reload()
	reset_pos(current_lev)
	playerStartPosition = player.global_transform.origin
	playerTotalDistance = 0

func _on_final_menu_next():
	current_lev += 1
	self.add_child(hard_levels[current_lev - 1])
	self.remove_child(hard_levels[current_lev - 2])
	hard_levels[current_lev - 2].queue_free()
	reload()
	reset_pos(current_lev)
	get_tree().paused = false
	playerStartPosition = player.global_transform.origin
	playerTotalDistance = 0

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

func reload():
	play_time = 0.0
	scoreboard.score = 1000
	final_menu.r1()
	timer.reset()
	timer.showTimer()
	scoreboard.showScore()
	map_visible(current_lev)

func map_visible(lev):
	if lev == 1:
		hard_map1.visible = true
		hard_map2.visible = false
		hard_map3.visible = false
	elif lev == 2:
		hard_map1.visible = false
		hard_map2.visible = true
		hard_map3.visible = false
	elif lev == 3:
		hard_map1.visible = false
		hard_map2.visible = false
		hard_map3.visible = true

func distanceScore(lev):
	if lev == 1:
		lev1Score = round(1000 * (54 / (playerTotalDistance / 4)))
		if lev1Score > 1000:
			lev1Score = 1000
		return lev1Score
	elif lev == 2:
		lev2Score = round(1000 * (33 / (playerTotalDistance / 4)))
		print(lev2Score)
		if lev2Score > 1000:
			lev2Score = 1000
		return lev2Score
	elif lev == 3:
		lev3Score = round(1000 * (49 / (playerTotalDistance / 4)))
		if lev3Score > 1000:
			lev3Score = 1000
		return lev3Score
