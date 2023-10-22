extends Control


#@onready var player:Node = get_node("../Player")

var cracks:Array[Sprite2D]


func _ready():
  cracks = [get_node("Crack1"), get_node("Crack2"), get_node("Crack3")]


func _process(delta:float):
  if Input.is_action_just_pressed("M1"): $ColorRect.color.a = 1
  $ColorRect.color.a = lerp($ColorRect.color.a, 0.0, 3*delta)
  #$Label.text = str(Engine.get_frames_per_second())


func update(value:int):
  $Label.text = str(value)
  # Lives left
  if 0 < value && value <= len(cracks):
    cracks[value-1].show()
  # No lives left
  else:
    for crack in cracks: crack.hide()
