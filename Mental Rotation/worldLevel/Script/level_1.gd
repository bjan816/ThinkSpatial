extends Node3D

#export files
@export_global_file("*") var NEXT_LEVEL: String = ""

func _on_same_button_body_entered(body):
	pass


func _on_same_button_area_entered(area):
	if area.is_in_group("bullet") and NEXT_LEVEL != "":
		get_tree().change_scene_to_file(NEXT_LEVEL)
		print("next level")
