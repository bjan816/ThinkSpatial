extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.003

#head bob var
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bobbing = 0.0

#FOV var
const BASE_FOV = 93.0
const FOV_CHANGE = 1.9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck = $FirstPersonNeck
@onready var camera = $FirstPersonNeck/Camera3D
@onready var gun_anim = $FirstPersonNeck/Camera3D/Pistol/AnimationPlayer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * _delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, _delta * 6.5)
			velocity.z = lerp(velocity.z, direction.z * speed, _delta * 6.5)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, _delta * 3.5)
		velocity.z = lerp(velocity.z, direction.z * speed, _delta * 3.5)
	
	# Head bob
	t_bobbing += _delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bobbing)
	
	# FOV
	var veloc_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * veloc_clamped
	camera.fov = lerp(camera.fov, target_fov, _delta * 8.0)
	
	move_and_slide()
	
	#shooting
	if Input.is_action_pressed("Mouse1"):
		if !gun_anim.is_playing():
			gun_anim.play("shooting")

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
