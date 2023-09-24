extends Node3D

#🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝🍝

const RAY_LENGTH = 100

var target
var level = 1
var lives = 3
var puzzle_time = 60
var is_moving
var movement_time = 10

func _ready():
	
	set_target()
	set_light()
	set_objects(11 - level)
	set_level_text(level)
	set_lives_text(lives)
	set_time_text(puzzle_time)
	set_movement_time_text(movement_time)
	
func _unhandled_input(_event):
	
	if (Input.is_action_pressed("backward") or Input.is_action_pressed("forward") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		
		is_moving = true
		
	else: is_moving = false
	
func _input(event):
	
	if (event.is_action_pressed("click")):
		
		var player_guess = guess()
		
		if player_guess.is_in_group("Targets"):
			
			if player_guess == target:
				
				player_guess.get_parent().material_override.albedo_color = Color(0, 1, 0)
				
				$PuzzleTimer.stop()
				await get_tree().create_timer(3).timeout
				
				player_guess.get_parent().material_override.albedo_color = Color(1, 1, 1)
				
				level += 1
				reset_puzzle(11 - level)
				
			elif player_guess != target:
				
				player_guess.get_parent().material_override.albedo_color = Color(1, 0, 0)
				
				$PuzzleTimer.stop()
				await get_tree().create_timer(3).timeout
				
				player_guess.get_parent().material_override.albedo_color = Color(1, 1, 1)
				
				lives -= 1
				
				if lives == 0:
					
					get_tree().quit()
					
				reset_puzzle(11 - level)
		
func reset_puzzle(num):
	
	var spawned = get_tree().get_nodes_in_group("Spawned")
	
	for element in spawned:
		
		element.remove_from_group("Spawned")
		element.queue_free()
		
	set_target()
	set_light()
	set_objects(num)
	set_level_text(level)
	set_lives_text(lives)
	puzzle_time = 60
	set_time_text(puzzle_time)
	movement_time = 10
	set_movement_time_text(movement_time)
	
	$Player.transform.origin = Vector3(0, 1, -16)
	$Player/Neck.rotation = Vector3(0, 0, 0)
	$Player/Neck/Camera3D.rotation = Vector3(0,0,0)
	
	$Player.SPEED = 5.0
	
	$PuzzleTimer.start()

func set_target():
	
	var cameras = get_tree().get_nodes_in_group("Cameras")
	var rand_num = randi() % cameras.size()
	var camera = cameras[rand_num]
	camera.make_current()
	
	var targets = get_tree().get_nodes_in_group("Targets")
	target = targets[rand_num]
	
func set_light():
	
	$Light.rotation_degrees.y = randf_range(0, 360)
	
func set_objects(num):
	
	var objects = get_tree().get_nodes_in_group("ToSpawn")
	
	for i in range(num):
		
		var to_spawn = objects[randi() % objects.size()].duplicate()
		
		var distance = 9 * sqrt(randf_range(0, 1))
		var degree = randf_range(0, 360)
		var height = randf_range(0, 4)
		
		var spawn_position = Vector3(
			distance * cos(deg_to_rad(degree)),
			height,
			distance * sin(deg_to_rad(degree))
		)
		
		self.add_child(to_spawn)
		to_spawn.add_to_group("Spawned")
		to_spawn.transform.origin = spawn_position
	
func guess():
	
	var camera = $Player.get_node("Neck/Camera3D")
	var space = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
		
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
	var ray = PhysicsRayQueryParameters3D.create(origin, end)
	ray.collide_with_areas = true
		
	var guessed = space.intersect_ray(ray)
	
	return guessed["collider"]
	
func set_level_text(level_num):
	
	var level_text = "Level: %d" % level_num
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/Level.text = level_text

func set_lives_text(lives_num):
	
	var lives_text = "Lives: %d" % lives_num
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/Lives.text = lives_text
	
func set_time_text(time_num):
	
	$UI/MarginContainer/VBoxContainer/HBoxContainer/Time.text = " " + str(time_num)
	
func set_movement_time_text(time_num):
	
	$UI/MarginContainer/VBoxContainer/MovementTime.text = " " + str(time_num)

func _on_puzzle_timer_timeout():
	
	puzzle_time -= 0.1
	var puzzle_time_label = $UI/MarginContainer/VBoxContainer/HBoxContainer/Time
	puzzle_time_label.text = " %.1f" % puzzle_time
		
	if puzzle_time <= 10:
		
		puzzle_time_label.add_theme_color_override("font_color", Color(1, 0, 0))
		
	else:
		
		puzzle_time_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	if puzzle_time <= 0:
		
		lives -= 1
		
		if lives == 0:
			
			get_tree().quit()
			
		reset_puzzle(11 - level)
		
	if is_moving == true:
		
		if movement_time > 0.1:

			movement_time -= 0.1
			set_movement_time_text("%.1f" % movement_time)
			
		else: $Player.SPEED = 0
			
func _on_tutorial_box_play():
	
	$Player.SPEED = 5.0
	$PuzzleTimer.start()
