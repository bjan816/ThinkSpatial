extends Control


func _input(event:InputEvent):
  if event is InputEventMouseButton:
    if Input.is_action_just_pressed("M2"):
      $ColorRect.color.a = 1


func _process(delta:float):
  $ColorRect.color.a = lerp($ColorRect.color.a, 0.0, 3*delta)
  $Label.text = str(Engine.get_frames_per_second())
