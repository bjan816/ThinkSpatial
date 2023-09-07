extends Node


func _ready():
  # Adapt resolution
  get_node("Top").set_size(get_viewport().get_size())
  get_node("Front").set_size(get_viewport().get_size())
  get_node("Left").set_size(get_viewport().get_size())
  get_node("Control/SubViewportContainer/SubViewport").set_size(get_viewport().get_size())
  
  # Set layer 1 false
  get_tree().call_group("Top",   "set_layer_mask_value", 1, false)
  get_tree().call_group("Front", "set_layer_mask_value", 1, false)
  get_tree().call_group("Left",  "set_layer_mask_value", 1, false)

  # Set layer n true
  get_tree().call_group("Top",   "set_layer_mask_value", 2, true)
  get_tree().call_group("Front", "set_layer_mask_value", 3, true)
  get_tree().call_group("Left",  "set_layer_mask_value", 4, true)
