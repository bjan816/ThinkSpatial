extends Node3D

EditorExportPlatformPC(String, FILE) var NEXT_LEVEL: String = ""
var bullet = preload("res://player/Scenes/bullets.tscn")

#func _on_area_3d_body_entered(body):
#	if bullet.has_method("answer"):
#		body.answer()
