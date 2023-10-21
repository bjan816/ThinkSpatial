extends Panel
class_name Scoreboard

var score: int = 1000
var resetButtonPressed = false
var hintButtonPressed = false
var hintUsed = false

func _process(delta) -> void:
	$Score.text = "Score: %01d" % score
	if Input.is_action_pressed('reset') and !resetButtonPressed:
		if score > 0:
			score -= 100
		resetButtonPressed = true
	elif !Input.is_action_pressed('reset'):
		resetButtonPressed = false
	if Input.is_action_pressed('hint') and !hintButtonPressed:
		if hintUsed == false:
			if score > 0:
				score -= 500
			hintButtonPressed = true
			hintUsed = true
	elif !Input.is_action_pressed('hint'):
		hintButtonPressed = false
	
func hideScore():
	self.visible = false

func showScore():
	self.visible = true
