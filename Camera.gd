extends Node3D


@export var faces:Array[Node3D]


func _input(event:InputEvent):
  if event is InputEventMouseMotion:
    if Input.is_action_pressed("M1"):
      rotation_degrees.x -= event.relative.y
      rotation_degrees.y -= event.relative.x
      for face in faces:
        face.rotation = rotation
