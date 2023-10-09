extends Node3D

#export files
@export_global_file("*") var NEXT_LEVEL: String = ""


func _on_same_button_area_entered(area):
	if area.is_in_group("bullet") and NEXT_LEVEL != "":
		get_tree().change_scene_to_file(NEXT_LEVEL)
		area.get_parent().material_override.albedo_color = Color(0,1,0)
		await get_tree().create_timer(2).timeout
		print("next level")



func _on_mirror_button_area_entered(area):
	pass # Replace with function body.
