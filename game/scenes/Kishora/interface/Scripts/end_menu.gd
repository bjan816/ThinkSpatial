extends Control

#signal retried()

@onready var Finalscore: = $CenterContainer/Panel/MarginContainer/EndScene/ScoreResults

var score: int = 500
var ResetButton = false

# Called when the node enters the scene tree for the first time.
func _initialize():
  var scoreNum = "Score: %s" % [score]
  Finalscore.text = scoreNum
  show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta) -> void:
#	if Input.is_action_pressed('reset') and !ResetButton:
#		if score > 0:
#			score -= 100
#		ResetButton = true
#	elif !Input.is_action_pressed('reset'):
#		ResetButton = false


func _on_try_again_pressed():
  emit_signal("retried")


func _on_quit_pressed():
  get_tree().quit()
