extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -300.0
const GRAVITY = Vector2(0,1200)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += GRAVITY * delta
		SPEED = 200
	else: 
		SPEED = 300.0

	#Jump
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left2", "right2")
	
	# Deceleration of movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func get_knockback(force: Vector2):
	velocity += force
