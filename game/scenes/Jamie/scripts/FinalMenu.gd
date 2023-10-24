extends Control
class_name FinalMenu

signal retried()
signal next()
signal exit()

@onready var time : = $CenterContainer/Column/Time
@onready var levelScore : = $CenterContainer/Column/LevelScore
@onready var distanceScore : = $CenterContainer/Column/DistanceScore
@onready var timeScore : = $CenterContainer/Column/TimeScore
@onready var totalScore : = $CenterContainer/Column/TotalScore
@onready var next_button : = $CenterContainer/Column/Row/NextLevel

var level_score: int = 1000
var distance_score: int = 1000
var time_score: int = 1000
var total_score: int = 0
var resetButtonPressed = false

func initialize(total_play_time : float) -> void:
	var minutes : String = str(int(total_play_time / 60.0))
	var seconds : String = str(int(fmod(total_play_time, 60.0)))
	
	var time_text = "Total time: %s m %s s" % [minutes, seconds]
	var level_score_text = "- Level Score: %s" % [level_score]
	var distance_score_text = "- Distance Score: %s" % [distance_score]
	total_score = level_score + distance_score + time_score
	var time_score_text = "- Time Score: %s" % [time_score] 
	var total_score_text = "Total Score: %s" % [total_score]
	
	time.text = time_text
	levelScore.text = level_score_text
	distanceScore.text = distance_score_text
	timeScore.text = time_score_text
	totalScore.text = total_score_text
	
	show()
	
func hide_menu():
	hide()
	
func hide_next_button():
	next_button.hide()

func _on_try_again_pressed():
	get_tree().paused = false
	emit_signal("retried")

func _on_exit_pressed():
	emit_signal("exit")
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://scenes/Home.tscn"))


func _on_next_level_pressed():
	get_tree().paused = false
	emit_signal("next")

