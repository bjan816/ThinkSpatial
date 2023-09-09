extends Node3D

const RAY_LENGTH = 100

func _ready():
	pass # Replace with function body.
	
func _input(event):
	
	if (event.is_action_pressed("click")):
		
		print(guess())

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
