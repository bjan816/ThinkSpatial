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

@onready var easy_map1 : = $Maps/Easy1
@onready var easy_map2 : = $Maps/Easy2
@onready var easy_map3 : = $Maps/Easy3
@onready var easy_map1_hint : = $Maps/Easy1/Hint
@onready var easy_map2_hint : = $Maps/Easy2/Hint
@onready var easy_map3_hint : = $Maps/Easy3/Hint

@onready var normal_map1 : = $Maps/Normal1
@onready var normal_map2 : = $Maps/Normal2
@onready var normal_map3 : = $Maps/Normal3
@onready var normal_map1_hint : = $Maps/Normal1/Hint
@onready var normal_map2_hint : = $Maps/Normal2/Hint
@onready var normal_map3_hint : = $Maps/Normal3/Hint

@onready var hard_map1 : = $Maps/Hard1
@onready var hard_map2 : = $Maps/Hard2
@onready var hard_map3 : = $Maps/Hard3
@onready var hard_map1_hint : = $Maps/Hard1/Hint
@onready var hard_map2_hint : = $Maps/Hard2/Hint
@onready var hard_map3_hint : = $Maps/Hard3/Hint

#Goal
@onready var goal : = $Goal

#Load levels
var easy_level = load("res://scenes/Jamie/world/EasyLevel.tscn").instantiate()
var hard_level = load("res://scenes/Jamie/world/HardLevel.tscn").instantiate()
var normal_level = load("res://scenes/Jamie/world/NormalLevel.tscn").instantiate()

#Easy levels setting
var easy_level_reset_pos = [Vector3(38, 1, 22), Vector3(46, 1, 14), Vector3(46, 1, 22)]
var easy_level_reset_angle = [Vector3(0, 180, 0), Vector3(0, 90, 0), Vector3(0, 90, 0)]
var easy_level_test_pos = [Vector3(-34, 1, 42), Vector3(42, 1, -42), Vector3(-18, 1, 46)]
var easy_level_goal_pos = [Vector3(14, 2, 46), Vector3(46, 2, 46), Vector3(14, 2, 38)]

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

var playCount = 1

#Player's stage score per level
var eLev1StageScore = 0
var eLev2StageScore = 0
var eLev3StageScore = 0
var nLev1StageScore = 0
var nLev2StageScore = 0
var nLev3StageScore = 0
var hLev1StageScore = 0
var hLev2StageScore = 0
var hLev3StageScore = 0
var levStageTotalScore = 0
var levStageScore = 0

#Player's distance score per level
var eLev1DistanceScore = 0
var eLev2DistanceScore = 0
var eLev3DistanceScore = 0
var nLev1DistanceScore = 0
var nLev2DistanceScore = 0
var nLev3DistanceScore = 0
var hLev1DistanceScore = 0
var hLev2DistanceScore = 0
var hLev3DistanceScore = 0
var levDistanceTotalScore = 0
var levDistanceScore = 0

#Player's time score per level
var eLev1TimeScore = 0
var eLev2TimeScore = 0
var eLev3TimeScore = 0
var nLev1TimeScore = 0
var nLev2TimeScore = 0
var nLev3TimeScore = 0
var hLev1TimeScore = 0
var hLev2TimeScore = 0
var hLev3TimeScore = 0
var levTimeTotalScore = 0
var levTimeScore = 0

#Player's Distance Variables
var playerStartPosition = Vector3(0, 0, 0)
var playerTotalDistance = 0.0
var playerFinalDistance = 0.0
var currentPos = 0.0
var distanceMoved = 0.0

var switch = false

func _input(_event):
  #If player presses 'B', it resets player's location
  if Input.is_action_pressed('reset'):	
    reset_pos(current_lev)
    #Did playerTotalDistance/2 because this value was added twice for no reason
    playerFinalDistance += playerTotalDistance/2
    playerTotalDistance = 0.0
  
  #Set the player location infront of the goal by pressing 'V'
  ###if Input.is_action_pressed('test'):	
    ###test_pos(current_lev)
    
  if Input.is_action_pressed('hint'):
    hint_visible(current_lev)

func _process(delta):
  #Calculates player's movement
  currentPos = player.global_transform.origin
  distanceMoved = currentPos.distance_to(playerStartPosition)
  playerTotalDistance += distanceMoved
  playerStartPosition = currentPos
  
  #Calculates play time
  play_time += delta
  
  #Check if the player entered tile where the goal is at
  if check_goal_lev(current_lev):
    _on_level_completed()

#Runs game when play button pressed
func _on_play_pressed():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  difficulty = 1
  self.add_child(easy_level)
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
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  get_tree().paused = true
  if current_lev == 3 and difficulty == 3:
    final_menu.hide_next_button()
  final_menu.level_score = stageScore(current_lev)
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
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  if current_lev == 3 and difficulty == 1:
    difficulty = 2
    current_lev = 1
    easy_level.queue_free()
    self.add_child(normal_level)
    switch = true
  elif current_lev == 3 and difficulty == 2:
    difficulty = 3
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
  playCount += 1

func _on_final_menu_exit():
  levStageScore = (eLev1StageScore+eLev2StageScore+eLev3StageScore+
          nLev1StageScore+nLev2StageScore+nLev3StageScore+
          hLev1StageScore+hLev2StageScore+hLev3StageScore)/playCount
  levDistanceScore = (eLev1DistanceScore+eLev2DistanceScore+eLev3DistanceScore+
            nLev1DistanceScore+nLev2DistanceScore+nLev3DistanceScore+
            hLev1DistanceScore+hLev2DistanceScore+hLev3DistanceScore)/playCount
  levTimeScore = (eLev1TimeScore+eLev2TimeScore+eLev3TimeScore+
          nLev1TimeScore+nLev2TimeScore+nLev3TimeScore+
          hLev1TimeScore+hLev2TimeScore+hLev3TimeScore)/playCount
  print("Average Score Score: ", levStageScore)
  print("Average Distance Score: ", levDistanceScore)
  print("Average Time Score: ", levTimeScore)
  print("Played: ", playCount)
  
#Check the goal location by checking current_lev
func check_goal_lev(lev):
  match difficulty:
    1: match lev:
      1: return (player.global_transform.origin.x > 13 and player.global_transform.origin.x < 15) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47)
      2: return (player.global_transform.origin.x > 45 and player.global_transform.origin.x < 47) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47)
      3: return (player.global_transform.origin.x > 13 and player.global_transform.origin.x < 15) and (player.global_transform.origin.z > 37 and player.global_transform.origin.z < 39)
    2: match lev:
      1: return (player.global_transform.origin.x > -35 and player.global_transform.origin.x < -33) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47)
      2: return (player.global_transform.origin.x > 37 and player.global_transform.origin.x < 39) and (player.global_transform.origin.z > -43 and player.global_transform.origin.z < -41)
      3: return (player.global_transform.origin.x > -23 and player.global_transform.origin.x < -21) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47)
    3: match lev:
      1: return (player.global_transform.origin.x > 29 and player.global_transform.origin.x < 31) and (player.global_transform.origin.z > 37 and player.global_transform.origin.z < 39)
      2: return (player.global_transform.origin.x > 37 and player.global_transform.origin.x < 39) and (player.global_transform.origin.z > -43 and player.global_transform.origin.z < -41)
      3: return (player.global_transform.origin.x > -39 and player.global_transform.origin.x < -37) and (player.global_transform.origin.z > 45 and player.global_transform.origin.z < 47)

#Resets the player location depends on the difficulty and the current_lev
func reset_pos(lev):
  if difficulty == 1:
    player.global_transform.origin = easy_level_reset_pos[lev - 1]
    player.rotation_degrees = easy_level_reset_angle[lev - 1]
    goal.global_transform.origin = easy_level_goal_pos[lev - 1]
  elif difficulty == 2:
    player.global_transform.origin = normal_level_reset_pos[lev - 1]
    player.rotation_degrees = normal_level_reset_angle[lev - 1]
    goal.global_transform.origin = normal_level_goal_pos[lev - 1]
  elif difficulty == 3:
    player.global_transform.origin = hard_level_reset_pos[lev - 1]
    player.rotation_degrees = hard_level_reset_angle[lev - 1]
    goal.global_transform.origin = hard_level_goal_pos[lev - 1]
  
func test_pos(lev):
  if difficulty == 1:
    player.global_transform.origin = easy_level_test_pos[lev - 1]
  elif difficulty == 2:
    player.global_transform.origin = normal_level_test_pos[lev - 1]
  elif difficulty == 3:
    player.global_transform.origin = hard_level_test_pos[lev - 1]

#When player retries or play next level, 
func reload():
  play_time = 0.0
  scoreboard.score = 1000
  final_menu.hide_menu()
  timer.reset()
  timer.showTimer()
  scoreboard.showScore()
  scoreboard.hintUsed = false
  map_visible(current_lev)

#Make the map related to each level visible by checking difficulty and current_lev
func map_visible(lev):
  maps.show()
  var mmm = [[easy_map1, easy_map2, easy_map3], [normal_map1, normal_map2, normal_map3], [hard_map1, hard_map2, hard_map3]]
  for mm in mmm:
    for m in mm:
      m.visible = false
  mmm[difficulty - 1][lev - 1].visible = true
  
func hint_visible(lev):
  var hints = [[easy_map1_hint, easy_map2_hint, easy_map3_hint], [normal_map1_hint, normal_map2_hint, normal_map3_hint], [hard_map1_hint, hard_map2_hint, hard_map3_hint]]
  hints[difficulty - 1][lev - 1].visible = true

func stageScore(lev):
  var s = scoreboard.score
  if difficulty == 1:
    if lev == 1:
      eLev1StageScore = s
      return eLev1StageScore
    elif lev == 2:
      eLev2StageScore = s
      return eLev2StageScore
    elif lev == 3:
      eLev3StageScore = s
      return eLev3StageScore
  elif difficulty == 2:
    if lev == 1:
      nLev1StageScore = s
      return nLev1StageScore
    elif lev == 2:
      nLev2StageScore = s
      return nLev2StageScore
    elif lev == 3:
      nLev3StageScore = s
      return nLev3StageScore
  elif difficulty == 3:
    if lev == 1:
      hLev1StageScore = s
      return hLev1StageScore
    elif lev == 2:
      hLev2StageScore = s
      return hLev2StageScore
    elif lev == 3:
      hLev3StageScore = s
      return hLev3StageScore

#Calculating score based on distance
func distanceScore(lev):
  var distances = [0, 0, 0]
  if difficulty == 1:
    distances = [12, 16, 12]
    if lev == 1:
      eLev1DistanceScore = round(1000 * (distances[0] / (playerFinalDistance / 4)))
      if eLev1DistanceScore > 1000:
        eLev1DistanceScore = 1000
      return eLev1DistanceScore
    elif lev == 2:
      eLev2DistanceScore = round(1000 * (distances[1] / (playerFinalDistance / 4)))
      if eLev2DistanceScore > 1000:
        eLev2DistanceScore = 1000
      return eLev2DistanceScore
    elif lev == 3:
      eLev3DistanceScore = round(1000 * (distances[2] / (playerFinalDistance / 4)))
      if eLev3DistanceScore > 1000:
        eLev3DistanceScore = 1000
      return eLev3DistanceScore
  elif difficulty == 2:
    distances = [39, 56, 48]
    if lev == 1:
      nLev1DistanceScore = round(1000 * (distances[0] / (playerFinalDistance / 4)))
      if nLev1DistanceScore > 1000:
        nLev1DistanceScore = 1000
      return nLev1DistanceScore
    elif lev == 2:
      nLev2DistanceScore = round(1000 * (distances[1] / (playerFinalDistance / 4)))
      if nLev2DistanceScore > 1000:
        nLev2DistanceScore = 1000
      return nLev2DistanceScore
    elif lev == 3:
      nLev3DistanceScore = round(1000 * (distances[2] / (playerFinalDistance / 4)))
      if nLev3DistanceScore > 1000:
        nLev3DistanceScore = 1000
      return nLev3DistanceScore
  elif difficulty == 3:
    distances = [54, 33, 49]
    if lev == 1:
      hLev1DistanceScore = round(1000 * (distances[0] / (playerFinalDistance / 4)))
      if hLev1DistanceScore > 1000:
        hLev1DistanceScore = 1000
      return hLev1DistanceScore
    elif lev == 2:
      hLev2DistanceScore = round(1000 * (distances[1] / (playerFinalDistance / 4)))
      if hLev2DistanceScore > 1000:
        hLev2DistanceScore = 1000
      return hLev2DistanceScore
    elif lev == 3:
      hLev3DistanceScore = round(1000 * (distances[2] / (playerFinalDistance / 4)))
      if hLev3DistanceScore > 1000:
        hLev3DistanceScore = 1000
      return hLev3DistanceScore

#Calculating score based on time
func timeScore(lev):
  if difficulty == 1:
    var t = 10
    var s = round(1000 * (t / play_time))
    if s > 1000:
      s = 1000
    if lev == 1:
      eLev1TimeScore = s
      return eLev1TimeScore
    elif lev == 2:
      eLev2TimeScore = s
      return eLev2TimeScore
    elif lev == 3:
      eLev3TimeScore = s
      return eLev3TimeScore
  elif difficulty == 2:
    var t = 45
    var s = round(1000 * (t / play_time))
    if s > 1000:
      s = 1000
    if lev == 1:
      nLev1TimeScore = s
      return nLev1TimeScore
    elif lev == 2:
      nLev2TimeScore = s
      return nLev2TimeScore
    elif lev == 3:
      nLev3TimeScore = s
      return nLev3TimeScore
  elif difficulty == 3:
    var t = 90
    var s = round(1000 * (t / play_time))
    if s > 1000:
      s = 1000
    if lev == 1:
      hLev1TimeScore = s
      return hLev1TimeScore
    elif lev == 2:
      hLev2TimeScore = s
      return hLev2TimeScore
    elif lev == 3:
      hLev3TimeScore = s
      return hLev3TimeScore
