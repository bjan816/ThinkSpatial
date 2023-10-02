extends Node


func _input(event:InputEvent):
  if Input.is_action_just_pressed("ui_accept"): to_home()


func to_home():
  to(load("res://scenes/Home.tscn"))


func to(packed:PackedScene):
  get_tree().change_scene_to_packed(packed)
