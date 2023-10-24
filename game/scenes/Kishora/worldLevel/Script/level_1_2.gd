extends Node3D

#export files
@export var NEXT_LEVEL: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_mirror_button_area_entered(area):
  if area.is_in_group("bullet") and NEXT_LEVEL != "":
    get_tree().change_scene_to_file(NEXT_LEVEL)
    print("next level")
