extends Node3D


@export var views:Array[Camera3D]


func _input(event:InputEvent):
  if event is InputEventMouseMotion:
    if Input.is_action_pressed("M1"):
      rotation_degrees.x -= event.relative.y
      rotation_degrees.y -= event.relative.x
      for view in views:
        view.global_transform = $Camera3D.global_transform
