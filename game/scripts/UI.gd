extends Control


func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(_delta:float):
  $Label.text = str(Engine.get_frames_per_second())
