extends CharacterBody3D

var SPEED = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D

func _unhandled_input(event):
	
	if event is InputEventMouseButton:
		#captures mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		#releases mouse on esc press
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x / 5
			rotation_degrees.x -= event.relative.y / 5
			rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)

func intput(action:String):
	return int(Input.is_action_pressed(action))

var v:Vector3

func _physics_process(_delta:float):
	v.x = intput("right") - intput("left")
	v.z = intput("backward") - intput("forward")
	v = v.normalized().rotated(Vector3.UP, rotation.y) * SPEED
	velocity = lerp(velocity, v, 0.1)
	move_and_slide()
