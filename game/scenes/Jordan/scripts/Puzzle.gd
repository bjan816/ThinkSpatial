extends Node3D

#🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝

var random = RandomNumberGenerator.new()

const RAY_LENGTH = 100

var target
var level = 1
var lives = 3
var puzzle_time = 60
var is_moving
var movement_time = 15

var mirror_mod
var ghost_mod
var memory_mod
var blur_mod

var has_guessed = false

func _ready():
	
	await get_tree().create_timer(0.05).timeout
	random.randomize()
	reset_puzzle()
	
func _unhandled_input(_event):
	
	if (Input.is_action_pressed("backward") or Input.is_action_pressed("forward") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		
		is_moving = true
		
	else: is_moving = false
	
	if memory_mod == true:
	
		if $Player/Neck/Camera3D/RayCast3D.get_collider() != $Screen/MeshInstance3D/StaticBody3D:
			
			$Screen.visible = false
			memory_mod = false

func _input(event):
	
	if (event.is_action_pressed("click")):
		
		var player_guess = guess()
		
		if player_guess.is_in_group("Targets") && has_guessed == false:
			
			has_guessed = true
			
			if player_guess == target:
				
				player_guess.get_parent().material_override.albedo_color = Color(0, 1, 0)
				
				$PuzzleTimer.stop()
				await get_tree().create_timer(3).timeout
				
				player_guess.get_parent().material_override.albedo_color = Color(1, 1, 1)
				
				level += 1
				reset_puzzle()
				
			elif player_guess != target:
				
				player_guess.get_parent().material_override.albedo_color = Color(1, 0, 0)
				
				$PuzzleTimer.stop()
				await get_tree().create_timer(3).timeout
				
				player_guess.get_parent().material_override.albedo_color = Color(1, 1, 1)
				
				lives -= 1
				
				if lives == 0:
					
					get_tree().quit()
					
				reset_puzzle()
		
func reset_puzzle():
	
	has_guessed = false
	
	var spawned = get_tree().get_nodes_in_group("Spawned")
	
	for element in spawned:
		
		element.remove_from_group("Spawned")
		element.queue_free()
	
	choose_modifier()
	set_screen()
	set_targets()
	set_target()
	set_light()
	set_objects()
	set_level_text(level)
	set_lives_text(lives)
	puzzle_time = 60
	set_time_text(puzzle_time)
	movement_time = 15
	set_movement_time_text(movement_time)
	
	$Player.transform.origin = Vector3(0, 1, -16)
	$Player/Neck.rotation = Vector3(0, 0, 0)
	$Player/Neck/Camera3D.rotation = Vector3(0,0,0)
	
	$Player.SPEED = 5.0
	
	$PuzzleTimer.start()
	
func choose_modifier():
	
	var modifiers = ["none", "mirror_mod", "ghost_mod", "memory_mod", "blur_mod"]
	var modifier = modifiers[randi() % modifiers.size()]
	print(modifier)
	
	if modifier == "none": return
	elif modifier == "mirror_mod": mirror_mod = true
	elif modifier == "ghost_mod": ghost_mod = true
	elif modifier == "memory_mod": memory_mod = true
	elif modifier == "blur_mod": blur_mod = true
	
func set_screen():
	
	$Screen.visible = true
	$Screen.flip_h = false
	
	if mirror_mod == true:
		
		$Screen.flip_h = true
		mirror_mod = false

func set_target():
	
	$Cameras/Camera.attributes.dof_blur_far_enabled = false
	
	var targets = get_tree().get_nodes_in_group("Targets")
	target = targets[random.randi_range(0, targets.size()-1)]
	$Cameras/Camera.global_transform.origin = target.global_transform.origin
	$Cameras/Camera.look_at(Vector3(0,0,0), Vector3.UP)
	
	if blur_mod == true:
		
		blur_mod = false
		$Cameras/Camera.attributes.dof_blur_far_enabled = true
		
func set_targets():
	
	var targets = get_tree().get_nodes_in_group("Targets")
	
	for i in range(targets.size()):
		
		target = targets[i].get_parent()
		
		var angle = randf_range(20, 160)
		target.global_transform.origin = Vector3(
			30 * sin(deg_to_rad(angle)),
			30 * cos(deg_to_rad(angle)),
			0
		)
		
		var parent_rotation = i * 45
		
		$Targets.rotation_degrees.y = parent_rotation
		var pos = target.global_transform.origin
		$Targets.rotation_degrees.y = 0
		target.global_transform.origin = pos
	
func set_light():
	
	$Light.rotation_degrees.y = randf_range(0, 360)
	
func set_objects():
	
	var objects = get_tree().get_nodes_in_group("ToSpawn")
	var num = random.randi_range(6, 10)
	
	for i in range(num):
		
		var to_spawn = objects[random.randi_range(0, objects.size()-1)].duplicate()
		
		var distance = 14 * sqrt(randf_range(0, 1))
		var degree = randf_range(0, 360)
		var height = randf_range(-5, 5)
		
		var spawn_position = Vector3(
			distance * cos(deg_to_rad(degree)),
			height,
			distance * sin(deg_to_rad(degree))
		)
		
		var spawn_rotation = Vector3(
			randf_range(0, 360),
			randf_range(0, 360),
			randf_range(0, 360)
		)
		
		self.add_child(to_spawn)
		to_spawn.add_to_group("Spawned")
		to_spawn.transform.origin = spawn_position
		to_spawn.rotation_degrees = spawn_rotation
		
		if i >= round(num - num * 0.3) && ghost_mod == true:
			
			to_spawn.layers = 2
			
	ghost_mod = false
	
func guess():
	
	var camera = $Player.get_node("Neck/Camera3D")
	var space = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
		
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var ray = PhysicsRayQueryParameters3D.create(origin, end)
	ray.collide_with_areas = true
	ray.set_exclude([$Environment/Floor/StaticBody3D.get_rid(), $Screen/MeshInstance3D/StaticBody3D.get_rid()])
		
	var guessed = space.intersect_ray(ray)
	
	return guessed["collider"]
	
func set_level_text(level_num):
	
	var level_text = "Level: %d" % level_num
	$UI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Level.text = level_text

func set_lives_text(lives_num):
	
	var lives_text = "Lives: %d" % lives_num
	$UI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Lives.text = lives_text
	
func set_time_text(time_num):
	
	$UI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Time.text = " " + str(time_num)
	
func set_movement_time_text(time_num):
	
	$UI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MovementTime.text = " " + str(time_num)

func _on_puzzle_timer_timeout():
	
	puzzle_time -= 0.1
	var puzzle_time_label = $UI/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Time
	set_time_text(" %.1f" % puzzle_time)
		
	if puzzle_time <= 10:
		
		puzzle_time_label.add_theme_color_override("font_color", Color(1, 0, 0))
		
	else:
		
		puzzle_time_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	if puzzle_time <= 0:
		
		lives -= 1
		
		if lives == 0:
			
			get_tree().quit()
			
		reset_puzzle()
		
	if is_moving == true:
		
		if movement_time > 0.1:

			movement_time -= 0.1
			set_movement_time_text("%.1f" % movement_time)
			
		else: $Player.SPEED = 0
