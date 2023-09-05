extends Control


func _process(_delta:float):
  $Label.text = str(Engine.get_frames_per_second())
