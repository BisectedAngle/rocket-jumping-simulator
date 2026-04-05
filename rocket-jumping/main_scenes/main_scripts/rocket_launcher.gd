extends Node2D

var ROCKET = preload("res://main_scenes/rocket.tscn")
@onready var nose = $Marker2D
@onready var cooldown_timer = $rocketCooldown

var rocket_counter = 0

func _process(delta):
	# Point gun to cursor
	look_at(get_global_mouse_position())

	# Flip direction of gun when rotated between 90 and 270 degrees
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1

	if Input.is_action_just_pressed("shoot1") and cooldown_timer.is_stopped():
		shoot()

func shoot():
	# Instantiate the rocket at the nose of the rocket
	var rocket_instance = ROCKET.instantiate()
	rocket_instance.global_position = nose.global_position
	rocket_instance.start_pos = rocket_instance.global_position
	rocket_instance.rotation = rotation
	rocket_instance.add_to_group("rockets")
	get_tree().root.add_child(rocket_instance)
	
	# Increment rocket counter
	rocket_counter += 1
	
	# Shooting cooldown timer
	cooldown_timer.start()
