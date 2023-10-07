extends Node3D



var targets
var puzzle_timer

func _ready():
	set_target()
	guess()
	
func _input(event):
	if event.is_action_pressed("Click"):
		var player_choice = guess()
		if player_choice.is_in_group("target_same"):
			if player_choice == targets:
				print("correct") 
	pass

func guess():
	var camera = $CharacterBody3D.get_node("FirstPersonNeck/Camera3D")
	var space = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	

func set_target():
	var targets = get_tree().get_nodes_in_group("Targets")
