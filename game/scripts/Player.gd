extends CharacterBody3D


func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event:InputEvent):
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
  v   = v.normalized().rotated(Vector3.UP, rotation.y)
  velocity = lerp(velocity, v, 0.1)
  move_and_slide()
