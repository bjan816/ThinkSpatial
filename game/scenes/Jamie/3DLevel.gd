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

@onready var goal : = $Goal

var level = load("res://scenes/Jamie/world/Level.tscn").instantiate()

var hard_level_reset_pos = [Vector3(-10, 1, -34), Vector3(-30, 1, 14), Vector3(30, 1, -2)]
var hard_level_reset_angle = [Vector3(0, 270, 0), Vector3(0, 270, 0), Vector3(0, 0, 0)]
var hard_level_test_pos = [Vector3(30, 1, 46), Vector3(30, 1, -42), Vector3(-32.5, 1, 46)]
var hard_level_goal_pos = [Vector3(30, 2, 38), Vector3(38, 2, -42), Vector3(-38, 2, 46)]
var play_time : = 0.0

var current_lev = 1

#Player's Score per level
var lev1DistanceScore = 0
var lev2DistanceScore = 0
var lev3DistanceScore = 0

var lev1TimeScore = 0
var lev2TimeScore = 0
var lev3TimeScore = 0

#Player's Distance Variables
var playerStartPosition = Vector3(0, 0, 0)
var playerTotalDistance = 0.0
var currentPos = 0.0
var distanceMoved = 0.0


func _ready():
	self.add_child(level)	
	reset_pos(current_lev)
	map_visible(current_lev)
	playerStartPosition = player.global_transform.origin
	
func _process(delta):
	#Calculates player's movement
	currentPos = player.global_transform.origin
	distanceMoved = currentPos.distance_to(playerStartPosition)
	playerTotalDistance += distanceMoved
	playerStartPosition = currentPos
	#print(playerTotalDistance)
	
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
	get_tree().paused = true
	if current_lev == 3:
		final_menu.hide_next_button()
	final_menu.level_score = scoreboard.score
	final_menu.distance_score = distanceScore(current_lev)
	final_menu.time_score = timeScore(current_lev)
	
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
	reload()
	reset_pos(current_lev)
	get_tree().paused = false
	playerStartPosition = player.global_transform.origin
	playerTotalDistance = 0

func check_goal_lev(lev):
	if lev == 1:
		if (player.global_transform.origin.x > 29 and player.global_transform.origin.x < 31) and (player.global_transform.origin.z > 37 and player.global_transform.origin.z < 39):
			return true
		else:
			return false
	elif lev == 2:
		if (player.global_transform.origin.x > 37 and player.global_transform.origin.x < 39) and (player.global_transform.origin.z > -43 and player.global_transform.origin.z < -41):
			return true
		else:
			return false
	elif lev == 3:
		if (player.global_transform.origin.x > -39 and player.global_transform.origin.x < -37) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47):
			return true
		else:
			return false

func reset_pos(lev):
	player.global_transform.origin = hard_level_reset_pos[lev - 1]
	player.rotation_degrees = hard_level_reset_angle[lev - 1]
	goal.global_transform.origin = hard_level_goal_pos[lev - 1]
	
func test_pos(lev):
	player.global_transform.origin = hard_level_test_pos[lev - 1]

func reload():
	play_time = 0.0
	scoreboard.score = 1000
	final_menu.hide_menu()
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
		lev1DistanceScore = round(1000 * (54 / (playerTotalDistance / 4)))
		if lev1DistanceScore > 1000:
			lev1DistanceScore = 1000
		return lev1DistanceScore
	elif lev == 2:
		lev2DistanceScore = round(1000 * (33 / (playerTotalDistance / 4)))
		if lev2DistanceScore > 1000:
			lev2DistanceScore = 1000
		return lev2DistanceScore
	elif lev == 3:
		lev3DistanceScore = round(1000 * (49 / (playerTotalDistance / 4)))
		if lev3DistanceScore > 1000:
			lev3DistanceScore = 1000
		return lev3DistanceScore

func timeScore(lev):
	var s = round(1000 * (180 / play_time))
	if s > 1000:
		s = 1000
	if lev == 1:
		lev1TimeScore = s
		return lev1TimeScore
	elif lev == 2:
		lev2TimeScore = s
		return lev2TimeScore
	elif lev == 3:
		lev3TimeScore = s
		return lev3TimeScore
