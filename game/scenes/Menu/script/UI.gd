extends Control


func _process(delta:float):
  $Label.text = str(Engine.get_frames_per_second())
  if $ColorRect.color.a > 0:
    $ColorRect.color.a -= delta
