extends Panel
class_name Tm

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _process(delta) -> void:
  time += delta
  msec = fmod(time, 1) * 100
  seconds = fmod(time, 60)
  minutes = fmod(time, 3600) / 60
  $Minutes.text = "%02d:" % minutes
  $Seconds.text = "%02d." % seconds
  $Msecs.text = "%02d" % msec
  

func get_time_formateed() -> String:
  return "%02d:%02d.%03d" % [minutes, seconds, msec]

func reset():
  time = 0.0
  minutes = 0
  seconds = 0
  msec = 0

func hideTimer():
  self.visible = false

func showTimer():
  self.visible = true