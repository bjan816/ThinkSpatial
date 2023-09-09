extends Node3D

const RAY_LENGTH = 200

var target
var level = 1
var lives = 3
var puzzle_time = 60

func _ready():
	
	set_target()
	set_light()
	set_objects(level)
	set_level_text(level)
	set_lives_text(lives)
	
func _input(event):
	
	if (event.is_action_pressed("click")):
		
		var player_guess = guess()
		
		if player_guess.is_in_group("Targets"):
			
			if player_guess == target:
				
				level += 1
				reset_puzzle(level)
				
			elif player_guess != target:
				
				lives -= 1
				
				if lives == 0:
					
					get_tree().quit()
					
				reset_puzzle(level)
		
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
	
	$Player.transform.origin = Vector3(0, 0, 20)
	$Player/Neck.rotation = Vector3(0, 0, 0)
	$Player/Neck/Camera3D.rotation = Vector3(0,0,0)

func set_target():
	
	var cameras = get_tree().get_nodes_in_group("Cameras")
	var rand_num = randi() % cameras.size()
	var camera = cameras[randi() % cameras.size()]
	camera.make_current()
	
	var targets = get_tree().get_nodes_in_group("Targets")
	target = targets[rand_num]
	
func set_light():
	
	$Light.rotation_degrees.y = randf_range(0, 360)
	
func set_objects(num):
	
	var objects = get_tree().get_nodes_in_group("ToSpawn")
	var max_range = Vector3(10, 5, 10)
	var min_range = Vector3(-10, 0, -10)
	
	for i in range(num):
		
		var to_spawn = objects[randi() % objects.size()].duplicate()
		
		var spawn_position = Vector3(
			randf_range(min_range.x, max_range.x),
			randf_range(min_range.y, max_range.y),
			randf_range(min_range.z, max_range.z)
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
		
	var collided = space.intersect_ray(ray)
	
	return collided["collider"]
	
func set_level_text(level_num):
	
	var level_text = "Level: %d" % level_num
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/Level.text = level_text
	
func set_lives_text(lives_num):
	
	var lives_text = "Lives: %d" % lives_num
	$UI/MarginContainer/VBoxContainer/HBoxContainer2/Lives.text = lives_text

func _on_puzzle_timer_timeout():
	
	puzzle_time -= 1
	var puzzle_time_label = $UI/MarginContainer/VBoxContainer/HBoxContainer/Time
	puzzle_time_label.text = str(puzzle_time)
	
	if puzzle_time <= 10:
		
		puzzle_time_label.add_theme_color_override("font_color", Color(1, 0, 0))
		
	if puzzle_time == 0:
		
		lives -= 1
		
		if lives == 0:
			
			get_tree().quit()
			
		reset_puzzle(level)
	
