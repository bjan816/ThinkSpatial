extends Control


func _process(delta:float):
  if Input.is_action_just_pressed("M1"): $ColorRect.color.a = 1
  $ColorRect.color.a = lerp($ColorRect.color.a, 0.0, 3*delta)
  $Label.text = str(Engine.get_frames_per_second())
