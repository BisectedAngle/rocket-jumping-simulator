extends CharacterBody2D

@export var SPEED = 300.0
@export var GRAVITY = 1200
@export var min_flip_time = 1.0  # Minimum seconds before switching direction
@export var max_flip_time = 3.0
@export var MAX_HEALTH = 150

var knockback_velocity: Vector2 = Vector2.ZERO
var health = MAX_HEALTH
var direction = 1
var rng = RandomNumberGenerator.new()

@onready var flip_timer := $flip_timer
@onready var collision_cloud_timer := $collision_cloud_timer
var can_spawn_collision := true

@onready var collision_cloud_scene := preload("res://pve/collision_cloud.tscn")
@onready var death_explosion_scene := preload("res://pve/enemies/death_explosion.tscn")
@onready var damage_number_scene := preload("res://pve/damage_number.tscn")
@onready var goal_scene := preload("res://tutorial/goal.tscn")

func _ready():
	rng.randomize()
	set_random_flip_time()

func set_random_flip_time():
	flip_timer.wait_time = rng.randf_range(min_flip_time, max_flip_time)

func _on_flip_timer_timeout() -> void:
	direction *= -1  # Flip direction
	set_random_flip_time() # Randomise the flip direction
	flip_timer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		# Make sure it doesn't accelerate infinitely when falling
		velocity.y = clamp(velocity.y, -2000, 1500)
		
	velocity.x = direction * SPEED + knockback_velocity.x
	move_and_slide()
	
	# Get all the things the walker collides with
	# If the thing is the player, then spawn damage cloud
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.name == "player1":
			# Damage is gotten from the collision cloud (10 dmg)
			var damage = spawn_collision_cloud()
			collider.take_enemy_damage(damage)

	knockback_velocity.x = move_toward(knockback_velocity.x, 0, 700 * delta)
	
	# Teleport back to top if it falls out of screen
	if position.y > 1080:
		global_position = Vector2(position.x,0)
		

func get_knockback(force: Vector2):
	velocity.y += force.y
	knockback_velocity.x += force.x * 0.7

func take_rocket_damage(damage,spawn_position):
	health -= damage
	# Spawn the damage number a bit above the explosion
	var damage_number = damage_number_scene.instantiate()
	damage_number.global_position = spawn_position + Vector2(0,-30)
	damage_number.set_text(str(damage))
	get_tree().current_scene.add_child(damage_number)
	
	if health <= 0:
		# Spawn death explosion
		var death_explosion = death_explosion_scene.instantiate()
		death_explosion.global_position = global_position
		death_explosion.set_color("22c70c")
		get_tree().current_scene.add_child(death_explosion)
		
		var scene_name = get_tree().get_current_scene().name
		
		#  If the scene is these tutorial levels, then spawn a goal
		if scene_name in ["tut_8","tut_10"]:
			var goal = goal_scene.instantiate()
			goal.global_position = Vector2(1780,330)
			get_tree().current_scene.add_child(goal)
			queue_free()
		else:
		# If not, then just update walkers killed stats
			get_parent().walkers -= 1
			get_parent().walkers_killed += 1
			
			queue_free()

func spawn_collision_cloud():
	if not can_spawn_collision:
		return 0
	
	can_spawn_collision = false
	collision_cloud_timer.start()
		
	var collision_cloud = collision_cloud_scene.instantiate()
	collision_cloud.global_position = global_position
	get_tree().current_scene.add_child(collision_cloud)
	
	# Deal 10 damage
	return 10

func _on_collision_cloud_timer_timeout() -> void:
	can_spawn_collision = true
	# Make sure there is collision cooldown, or damage and death will be instant
