extends Node3D
class_name Game

#Difficulty Menu
@onready var diff : = $DifficultyMenu

#Final Menu
@onready var final_menu : = $FinalMenu

#Player
@onready var player : = $Player

#Timer
@onready var timer : = $Timer

#Scoreboard
@onready var scoreboard : = $Scoreboard

#Map variables
@onready var maps : = $Maps
@onready var normal_map1 : = $Maps/Normal1
@onready var normal_map2 : = $Maps/Normal2
@onready var normal_map3 : = $Maps/Normal3
@onready var hard_map1 : = $Maps/Hard1
@onready var hard_map2 : = $Maps/Hard2
@onready var hard_map3 : = $Maps/Hard3

#Goal
@onready var goal : = $Goal

#Load levels
var hard_level = load("res://scenes/Jamie/world/HardLevel.tscn").instantiate()
var normal_level = load("res://scenes/Jamie/world/NormalLevel.tscn").instantiate()

#Normal levels setting
var normal_level_reset_pos = [Vector3(14, 1, -14), Vector3(46, 1, 14), Vector3(6, 1, 2)]
var normal_level_reset_angle = [Vector3(0, 180, 0), Vector3(0, 90, 0), Vector3(0, 90, 0)]
var normal_level_test_pos = [Vector3(-34, 1, 42), Vector3(42, 1, -42), Vector3(-18, 1, 46)]
var normal_level_goal_pos = [Vector3(-34, 2, 46), Vector3(38, 2, -42), Vector3(-22, 2, 46)]

#Hard levels setting
var hard_level_reset_pos = [Vector3(-10, 1, -34), Vector3(-30, 1, 14), Vector3(30, 1, -2)]
var hard_level_reset_angle = [Vector3(0, 270, 0), Vector3(0, 270, 0), Vector3(0, 0, 0)]
var hard_level_test_pos = [Vector3(30, 1, 46), Vector3(30, 1, -42), Vector3(-32, 1, 46)]
var hard_level_goal_pos = [Vector3(30, 2, 38), Vector3(38, 2, -42), Vector3(-38, 2, 46)]

#Game play time
var play_time : = 0.0

#Difficulty of the game
var difficulty = 1

#Current level
var current_lev = 1

#Player's distance score per level
var lev1DistanceScore = 0
var lev2DistanceScore = 0
var lev3DistanceScore = 0

#Player's time score per level
var lev1TimeScore = 0
var lev2TimeScore = 0
var lev3TimeScore = 0

#Player's Distance Variables
var playerStartPosition = Vector3(0, 0, 0)
var playerTotalDistance = 0.0
var playerFinalDistance = 0.0
var currentPos = 0.0
var distanceMoved = 0.0

var switch = false

func _process(delta):
	#Calculates player's movement
	currentPos = player.global_transform.origin
	distanceMoved = currentPos.distance_to(playerStartPosition)
	playerTotalDistance += distanceMoved
	playerStartPosition = currentPos
	
	#Calculates play time
	play_time += delta
	
	#If player presses 'B', it resets player's location
	if Input.is_action_pressed('reset'):	
		reset_pos(current_lev)
		#Did playerTotalDistance/2 because this value was added twice for no reason
		playerFinalDistance += playerTotalDistance/2
		playerTotalDistance = 0.0
	
	#Set the player location infront of the goal by pressing 'V'
	if Input.is_action_pressed('test'):	
		test_pos(current_lev)
	
	#Check if the player entered tile where the goal is at
	if check_goal_lev(current_lev):
		_on_level_completed()

#Runs game when play button pressed
func _on_play_pressed():
	difficulty = 1
	self.add_child(normal_level)
	diff.hide()
	playerFinalDistance = 0.0
	playerTotalDistance = 0.0
	reset_pos(current_lev)
	playerStartPosition = player.global_transform.origin
	timer.show()
	scoreboard.show()
	reload()

#When the level completed
func _on_level_completed():
	get_tree().paused = true
	if current_lev == 3 and difficulty == 2:
		final_menu.hide_next_button()
	final_menu.level_score = scoreboard.score
	playerFinalDistance += playerTotalDistance
	final_menu.distance_score = distanceScore(current_lev)
	final_menu.time_score = timeScore(current_lev)
	maps.hide()
	final_menu.initialize(play_time)
	timer.hideTimer()
	scoreboard.hideScore()

#When the player retries the level
func _on_final_menu_retried():
	reload()
	reset_pos(current_lev)
	playerStartPosition = player.global_transform.origin
	playerFinalDistance = 0.0
	playerTotalDistance = 0.0

#When the player presses 'Next' button
func _on_final_menu_next():
	if current_lev == 3 and difficulty == 1:
		difficulty = 2
		current_lev = 1
		normal_level.queue_free()
		self.add_child(hard_level)
		switch = true
	if !switch:
		current_lev += 1
	if switch == true:
		switch = false
	reload()
	reset_pos(current_lev)
	get_tree().paused = false
	playerStartPosition = player.global_transform.origin
	playerFinalDistance = 0.0
	playerTotalDistance = 0.0

#Check the goal location by checking current_lev
func check_goal_lev(lev):
	if difficulty == 1:
		if lev == 1:
			if (player.global_transform.origin.x > -35 and player.global_transform.origin.x < -33) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47):
				return true
			else:
				return false
		elif lev == 2:
			if (player.global_transform.origin.x > 37 and player.global_transform.origin.x < 39) and (player.global_transform.origin.z > -43 and player.global_transform.origin.z < -41):
				return true
			else:
				return false
		elif lev == 3:
			if (player.global_transform.origin.x > -23 and player.global_transform.origin.x < -21) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47):
				return true
			else:
				return false
	else:
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

#Resets the player location depends on the difficulty and the current_lev
func reset_pos(lev):
	if difficulty == 1:
		player.global_transform.origin = normal_level_reset_pos[lev - 1]
		player.rotation_degrees = normal_level_reset_angle[lev - 1]
		goal.global_transform.origin = normal_level_goal_pos[lev - 1]
	else:
		player.global_transform.origin = hard_level_reset_pos[lev - 1]
		player.rotation_degrees = hard_level_reset_angle[lev - 1]
		goal.global_transform.origin = hard_level_goal_pos[lev - 1]
	
func test_pos(lev):
	if difficulty == 1:
		player.global_transform.origin = normal_level_test_pos[lev - 1]
	else:
		player.global_transform.origin = hard_level_test_pos[lev - 1]

#When player retries or play next level, 
func reload():
	play_time = 0.0
	scoreboard.score = 1000
	final_menu.hide_menu()
	timer.reset()
	timer.showTimer()
	scoreboard.showScore()
	map_visible(current_lev)

#Make the map related to each level visible by checking difficulty and current_lev
func map_visible(lev):
	maps.show()
	if difficulty == 1:
		if lev == 1:
			normal_map1.visible = true
			normal_map2.visible = false
			normal_map3.visible = false
			hard_map1.visible = false
			hard_map2.visible = false
			hard_map3.visible = false
		elif lev == 2:
			normal_map1.visible = false
			normal_map2.visible = true
			normal_map3.visible = false
			hard_map1.visible = false
			hard_map2.visible = false
			hard_map3.visible = false
		elif lev == 3:
			normal_map1.visible = false
			normal_map2.visible = false
			normal_map3.visible = true
			hard_map1.visible = false
			hard_map2.visible = false
			hard_map3.visible = false
	else:
		if lev == 1:
			normal_map1.visible = false
			normal_map2.visible = false
			normal_map3.visible = false
			hard_map1.visible = true
			hard_map2.visible = false
			hard_map3.visible = false
		elif lev == 2:
			normal_map1.visible = false
			normal_map2.visible = false
			normal_map3.visible = false
			hard_map1.visible = false
			hard_map2.visible = true
			hard_map3.visible = false
		elif lev == 3:
			normal_map1.visible = false
			normal_map2.visible = false
			normal_map3.visible = false
			hard_map1.visible = false
			hard_map2.visible = false
			hard_map3.visible = true

#Calculating score based on distance
func distanceScore(lev):
	var distances = [0, 0, 0]
	
	if difficulty == 1:
		distances = [39, 56, 48]
	else:
		distances = [54, 33, 49]
		
	if lev == 1:
		lev1DistanceScore = round(1000 * (distances[0] / (playerFinalDistance / 4)))
		if lev1DistanceScore > 1000:
			lev1DistanceScore = 1000
		return lev1DistanceScore
	elif lev == 2:
		lev2DistanceScore = round(1000 * (distances[1] / (playerFinalDistance / 4)))
		if lev2DistanceScore > 1000:
			lev2DistanceScore = 1000
		return lev2DistanceScore
	elif lev == 3:
		lev3DistanceScore = round(1000 * (distances[2] / (playerFinalDistance / 4)))
		if lev3DistanceScore > 1000:
			lev3DistanceScore = 1000
		return lev3DistanceScore

#Calculating score based on time
func timeScore(lev):
	var t = 0
	if difficulty == 1:
		t = 45
	else:
		t = 90
	var s = round(1000 * (t / play_time))
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
