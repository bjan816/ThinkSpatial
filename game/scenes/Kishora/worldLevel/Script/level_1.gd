extends Node3D


#export files
@export var NEXT_LEVEL: String = ""


func _on_same_button_area_entered(area):
  if area.is_in_group("bullet") and NEXT_LEVEL != "":
    get_tree().change_scene_to_file(NEXT_LEVEL)
    #self.material_albedo = Color(0.0 ,1.0 ,0.0)
    await get_tree().create_timer(9).timeout
    print("next level")


func _on_mirror_button_area_entered(area):
  return
  if area.is_in_group("bullet"):
    show_game_over_screen()
    queue_free()
    
func show_game_over_screen():
  var game_over_screen = preload("res://scenes/Kishora/interface/Scenes/end_menu.tscn").instantiate()
  add_child(game_over_screen)
  
