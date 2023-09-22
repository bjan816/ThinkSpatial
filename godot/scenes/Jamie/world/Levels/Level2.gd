extends Node3D
@onready var goal : = $Goal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print('goal x = ' + str(goal.global_transform.origin.x))
	print('goal z = ' + str(goal.global_transform.origin.z))
