class_name Puzzle
extends StaticBody3D


@export var to:Node3D
@export var pieces:Array[MeshInstance3D]

var animate:= false


func _process(delta:float):
  if animate:
    rotation.y += delta
    position = lerp(position, to.position, delta)
    rotation = lerp(rotation, to.rotation, delta)
    scale    = lerp(scale,    to.scale,    delta)


func check(your_cam:Vector3):
  var my_cam:Vector3 = get_node("../Camera").global_position
  if my_cam.distance_to(your_cam) < 1:
    animate = true
    show()
    to.hide()
    for piece in pieces: piece.hide()
    return true
  return false
