extends Control
class_name FinalMenu

signal retried()
signal next()

@onready var time : = $CenterContainer/Column/Time
@onready var score_obj : = $CenterContainer/Column/Score

var score: int = 1000
var resetButtonPressed = false

func _process() -> void:
	if Input.is_action_pressed('reset') and !resetButtonPressed:
		if score > 0:
			score -= 100
		resetButtonPressed = true
	elif !Input.is_action_pressed('reset'):
		resetButtonPressed = false

func initialize(total_play_time : float) -> void:
	var minutes : String = str(int(total_play_time / 60.0))
	var seconds : String = str(int(fmod(total_play_time, 60.0)))
	var time_text = "Total time: %s m %s s" % [minutes, seconds]
	var score_text = "Total Score: %s" % [score]
	time.text = time_text
	score_obj.text = score_text
	show()

func _on_try_again_pressed():
	get_tree().paused = false
	emit_signal("retried")

func _on_exit_pressed():
	get_tree().quit()


func _on_next_level_pressed():
	get_tree().paused = false
	emit_signal("next")

