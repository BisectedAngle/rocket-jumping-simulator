extends CharacterBody2D

# These are exports so I can change them depending on the scene the player is in
@export var SPEED = 500.0
@export var JUMP_VELOCITY = -300.0
@export var GRAVITY = 1200
@export var MAX_HEALTH = 150

var knockback_velocity: Vector2 = Vector2.ZERO
var health = MAX_HEALTH

# These are some (child) nodes that can be altered by the code
# death_scene is not a child node, but is to be instantiated upon death
@onready var health_bar := $health_bar
@onready var health_label := $health_label
@onready var death_scene := preload("res://pve/death_screen.tscn")
@onready var pause_menu_scene := preload("res://main_scenes/pause_menu.tscn")


@onready var rocket_launcher := $rocket_launcher

#=============================================================================

func set_health_bar():
	health_bar.value = health

func set_health_label():
	health_label.text = str(health)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
		#Clamping velocity so player doesn't accelerate infinitely when falling down infinitely
		velocity.y = clamp(velocity.y, -2000, 1500)
	
	# Jump
	if Input.is_action_just_pressed("jump1") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input movement
	var direction := Input.get_axis("left1", "right1")
	var input_velocity := Vector2.ZERO
	
	if direction:
		input_velocity.x = direction * SPEED
	else:
		input_velocity.x = move_toward(velocity.x, 0, SPEED)

	# Combine input + knockback
	velocity.x = input_velocity.x + knockback_velocity.x

	# Apply movement
	move_and_slide()

	# Dampen horizontal knockback gradually (because this guy kept sliding)
	knockback_velocity.x = move_toward(knockback_velocity.x, 0, 500 * delta)

	set_health_bar()
	set_health_label()
	
	# Teleport back to top if it falls out of screen
	if position.y > 1080:
		global_position = Vector2(position.x,0)
	
	
	# Spawn pause menu
	var scene_name = get_tree().get_current_scene().name
	if scene_name != "title_screen":
		if Input.is_action_just_pressed("ui_cancel") and is_on_floor():
			var pause_menu = pause_menu_scene.instantiate()
			pause_menu.global_position = Vector2(960,520)
			get_tree().current_scene.add_child(pause_menu)

#=============================================================================

func get_knockback(force: Vector2):
	velocity.y += force.y
	knockback_velocity.x += force.x * 0.7 # Even more velocity damping

func heal(healing):
	# Make sure health does not exceed max health when healing
	health = clamp(health+healing, 0, 150)

func take_enemy_damage(damage):
	health -= damage
	if health <= 0:
		# There are different processes depending on what scene the player is in
		var scene_name = get_tree().get_current_scene().name
		if scene_name in ["tut_8","tut_9","tut_10","tut_11"]:
			# Reload the scene if the player dies during tutorial
			get_tree().reload_current_scene()
		else:
			# Display the death scene if the player dies during pve
			get_tree().paused = true
			var death_screen = death_scene.instantiate()
			death_screen.global_position = Vector2(960,540)
			get_tree().current_scene.add_child(death_screen)
