extends Node3D

@export_global_file("*") var NEXT_LEVEL: String = ""

func _on_same_button_body_entered(body):
	if body.is_in_group("player") and NEXT_LEVEL != "":
		get_tree().change_scene_to_file(NEXT_LEVEL)
		print("next level")
