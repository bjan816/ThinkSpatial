extends Node3D


# READY
# ——————————————————————————————————————————————————————————————————————————————
func _ready():
  query = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.ZERO)


# INPUT
# ——————————————————————————————————————————————————————————————————————————————
@export var views:Array[Camera3D]
@onready var cam:Camera3D = $Camera

var query:PhysicsRayQueryParameters3D


func _input(event:InputEvent):
  
  if event is InputEventMouseButton:
    if Input.is_action_just_pressed("M1"):
      query.from = cam.project_ray_origin(event.position)
      query.to   = cam.project_ray_normal(event.position) * 10 + query.from
      if collide(query):
        collide(query).collider.check(cam.global_position)
  
  if event is InputEventMouseMotion:
    if Input.is_action_pressed("M2"):
      rotation_degrees.x -= event.relative.y
      rotation_degrees.y -= event.relative.x
      for view in views:
        view.global_transform = cam.global_transform


func collide(ray_query:PhysicsRayQueryParameters3D):
  var world = get_world_3d().direct_space_state
  return world.intersect_ray(ray_query)


# PROCESS
# executes at every frame
# ——————————————————————————————————————————————————————————————————————————————
func _process(delta):
  pass
