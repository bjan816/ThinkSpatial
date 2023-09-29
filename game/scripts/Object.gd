extends StaticBody3D
class_name Trigger


@export var path:String

@onready var mat:Material = get_node("MeshInstance3D").get_active_material(0)
@onready var hlt_mat:ShaderMaterial = preload("res://assets/material/Highlight.tres")


func _input(event:InputEvent):
  if event is InputEventMouseButton:
    if path != ""  && mat.next_pass != null:
      Global.to(path)


func _on_mouse_entered():
  mat.next_pass = hlt_mat
  if get_node_or_null("Label3D"): $Label3D.show()


func _on_mouse_exited():
  mat.next_pass = null
  if get_node_or_null("Label3D"): $Label3D.hide()
