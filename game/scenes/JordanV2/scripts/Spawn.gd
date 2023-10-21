extends Node3D


const r:= 0.5 # radius

var meshes:= [
  BoxMesh.new(),
  CapsuleMesh.new(),
  CylinderMesh.new(),
  PrismMesh.new(),
  SphereMesh.new()
]


func _ready():
  var n = randi_range(5, 10)
  
  for i in range(n):
	# new
	var mesh  = MeshInstance3D.new()
	mesh.mesh = meshes[randi() % meshes.size()]
	#mesh.mesh = BoxMesh.new()
	mesh.material_override = load("res://assets/material/PaynesGray.tres")
	
	# add to tree
	add_child(mesh)
	
	# (x,y,z) random position within a radius of 0.5
	mesh.global_translate(
	  Vector3.RIGHT * sqrt(randf_range(0.0, r)) * cos(randf_range(-PI, PI)) +
	  Vector3.UP    * randf_range(-r, r) +
	  Vector3.BACK  * sqrt(randf_range(0.0, r)) * sin(randf_range(-PI, PI))
	)
	# (x,y,z) random rotation within a range of -180 to 180 degrees
	mesh.global_rotate(Vector3.RIGHT, randf_range(-PI, PI))
	mesh.global_rotate(Vector3.UP,    randf_range(-PI, PI))
	mesh.global_rotate(Vector3.BACK,  randf_range(-PI, PI))
	# vec3(0.1) scale
	mesh.global_scale(Vector3.ONE * 0.1)
