extends Panel
class_name Scoreboard

var score: int = 1000
var resetButtonPressed = false

func _process(delta) -> void:
	$Score.text = "Score: %01d" % score
	if Input.is_action_pressed('reset') and !resetButtonPressed:
		if score > 0:
			score -= 100
		resetButtonPressed = true
	elif !Input.is_action_pressed('reset'):
		resetButtonPressed = false
	
func hideScore():
	self.visible = false

func showScore():
	self.visible = true
