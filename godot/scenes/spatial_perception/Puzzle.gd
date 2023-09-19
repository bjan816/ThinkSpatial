class_name Puzzle
extends StaticBody3D


@export var pieces:Array[MeshInstance3D]

var animate:= false


func _process(delta:float):
  if animate:
    rotation.y += delta
    position = lerp(position, Vector3.ZERO,            delta)
    rotation = lerp(rotation, Vector3.UP * rotation.y, delta)
    scale    = lerp(scale,    Vector3.ONE * 2,         delta)


func check(your_cam:Vector3):
  var my_cam:Vector3 = get_node("../Camera").global_position
  if my_cam.distance_to(your_cam) < 1:
    for piece in pieces: piece.hide()
    show()
    animate = true
