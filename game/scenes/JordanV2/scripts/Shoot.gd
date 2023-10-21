extends Node3D


@onready var cam:Camera3D = get_node("SubViewport/Camera3D")

const N:= 6.0
const r:= 2.0 # radius


func _ready():
  var j = randi_range(0, N-1)
  cam.global_translate(
	Vector3.RIGHT * sqrt(r) * cos(deg_to_rad(360/N*j)) +
	Vector3.BACK  * sqrt(r) * sin(deg_to_rad(360/N*j))
  )
  cam.look_at(Vector3.ZERO)
  
  for i in range(N):
	if i==j: continue
	
	# new
	var mesh  = MeshInstance3D.new()
	mesh.mesh = SphereMesh.new()
	mesh.material_override = load("res://assets/material/SpaceCadet.tres")
	mesh.set_layer_mask_value(1, false)
	mesh.set_layer_mask_value(2, true)
	
	# add to tree
	add_child(mesh)
	
	# positions partitioned in angles of 360/N
	mesh.global_translate(
	  Vector3.RIGHT * sqrt(r) * cos(deg_to_rad(360/N*i)) +
	  Vector3.BACK  * sqrt(r) * sin(deg_to_rad(360/N*i))
	)
	mesh.global_scale(Vector3.ONE * 0.1)
