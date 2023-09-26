extends Control

func _on_borim_pressed():
  #get_tree().change_scene_to_file()
  pass

func _on_jamie_pressed():
  get_tree().change_scene_to_file("res://scenes/Jamie/3DLevel.tscn")

func _on_jordan_pressed():
  get_tree().change_scene_to_file("res://scenes/Jordan/scenes/Puzzle.tscn")

func _on_sun_pressed():
  get_tree().change_scene_to_file("res://scenes/Sun/scenes/Demo.tscn")
