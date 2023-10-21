extends StaticBody3D
class_name Trigger


@export var path:PackedScene

@onready var mat:Material = get_node("MeshInstance3D").get_active_material(0).next_pass
@onready var hlt_mat:ShaderMaterial = preload("res://assets/material/Highlight.tres")


func _input(event:InputEvent):
  
  if event is InputEventMouseButton:
    if path != null && mat.get_shader_parameter("border") > 0.0625:
      Global.to(path)


func _on_mouse_entered():
  mat.set_shader_parameter("border", 0.125)
  if get_node_or_null("Label3D"): $Label3D.show()


func _on_mouse_exited():
  mat.set_shader_parameter("border", 0.03125)
  if get_node_or_null("Label3D"): $Label3D.hide()
