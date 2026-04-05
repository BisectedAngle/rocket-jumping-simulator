extends CPUParticles2D

@onready var animation_timer := $animation_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_timer.wait_time = 0.95
	animation_timer.start()

func _on_animation_timer_timeout() -> void:
	queue_free()
	
