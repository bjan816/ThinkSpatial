extends StaticBody3D


@export var path:String

# TODO make exported variable "mesh", and the material attached to the mesh:
# @export var mesh
# @onready var mat = mesh.get_active_matieral()

@export var mat:Material
@onready var mesh:MeshInstance3D = get_node("MeshInstance3D")

@onready var hlt_mat:ShaderMaterial = preload("res://asset/material/Highlight.tres")


func _ready():
  if mat:     mesh.set_surface_override_material(0, mat)
  else: mat = mesh.get_surface_override_material(0)


func _input(event:InputEvent):
  if event is InputEventMouseButton:
    if path != ""  && mat.next_pass != null:
      Global.to(path)


func _on_mouse_entered():
  mat.next_pass = hlt_mat


func _on_mouse_exited():
  mat.next_pass = null
