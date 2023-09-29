extends Node3D


@onready var ui:Control = get_node("../Control")

var health:= 5


# INPUT
# ——————————————————————————————————————————————————————————————————————————————
@export var views:Array[Camera3D]
@onready var cam:Camera3D = $Camera


func _input(event:InputEvent):
  # Look
  if event is InputEventMouseButton and Input.is_action_just_pressed("M1"):
    # Create query
    var from = cam.project_ray_origin(event.position)
    var to   = cam.project_ray_normal(event.position) * 10 + from
    var query = PhysicsRayQueryParameters3D.create(from, to)
    # Check query
    if collide(query):
      # Incorrect transformation
      if not collide(query).collider.check(cam.global_position):
        health -= 1
    else:
      health -= 1
    ui.update(health)
    if health < 1:
      get_tree().change_scene_to_file("res://scenes/Menu/Menu.tscn")
  
  # Move
  if event is InputEventMouseMotion and Input.is_action_pressed("M2"):
    # Rotate my camera
    rotation_degrees.x -= event.relative.y
    rotation_degrees.y -= event.relative.x
    # Rotate their cameras
    for view in views: view.global_transform = cam.global_transform


func collide(query:PhysicsRayQueryParameters3D):
  var world = get_world_3d().direct_space_state
  return world.intersect_ray(query)
