extends Label

@onready var fadeout_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate.a = 1.0 # Beginning alpha (opacity) of the damage number
	
	# Tween the explosion appearance so it fades out over 0.5s
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)

	fadeout_timer.start() # The timer is 0.5s which matches the explosion fadeout

func _on_timer_timeout():
	queue_free()
