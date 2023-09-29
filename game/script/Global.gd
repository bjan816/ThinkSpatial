extends Node


func _input(event:InputEvent):
  if Input.is_action_just_pressed("ui_accept"):
    get_tree().change_scene_to_file("res://scene/Home.tscn")


func to(file:String):
  get_tree().change_scene_to_file(file)
