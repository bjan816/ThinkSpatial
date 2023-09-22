extends StaticBody3D


@export var scene:PackedScene
@export var mat:Material

@onready var mesh:MeshInstance3D = get_node("MeshInstance3D")
@onready var hlt_mat:ShaderMaterial = preload("res://asset/material/Highlight.tres")
"""
shader_type spatial;
render_mode unshaded,cull_front,depth_draw_never;

uniform float border = 0.1;

void vertex() {
  VERTEX += VERTEX * border;
}
"""


func _ready():
  if mat:     mesh.set_surface_override_material(0, mat)
  else: mat = mesh.get_surface_override_material(0)


func _input(event:InputEvent):
  if event is InputEventMouseButton:
    if mat.next_pass != null and scene != null:
      get_tree().change_scene_to_packed(scene)


func _on_mouse_entered():
  mat.next_pass = hlt_mat


func _on_mouse_exited():
  mat.next_pass = null
