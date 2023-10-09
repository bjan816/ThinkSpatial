extends Node3D
class_name Bullet

const SPEED = 40.0

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D
@onready var particles = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0,0,-SPEED) * delta
	if raycast.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
	


func _on_timer_timeout():
	queue_free()


func _on_area_3d_body_entered(body):
	if body.name == "Mirror":
		print("Mirror chose")
	elif body.name == "Same":
		print("Same chose")
