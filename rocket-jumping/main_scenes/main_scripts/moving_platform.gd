extends Path2D

@export var loop = false
@export var speed = 4.5
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
# =======================================================

func _ready():
	# Animation will only play if the path doesn't loop (like a circle)
	# But all paths I designed don't loop so it will always play
	if not loop:
		animation.play("move_horizontal")
		
		# Can alter speed of animation
		animation.speed_scale = speed_scale
		set_process(false)

func _process(delta):
	# Increase position of path by the speed
	# Allows for dynamic manipulation of speed
	path.progress += speed
