extends CharacterBody2D

var explosion_scene = preload("res://main_scenes/explosion.tscn")
var ROCKET_LAUNCHER = preload("res://main_scenes/rocket_launcher.tscn")
var scale_basedon_scene = 1.6

@export var SPEED = 550.0
@export var BASE_DAMAGE = 115
@export var DMG_CONSTANT = 0.45
@export var MIN_DAMAGE = 30

@onready var rocket = $Sprite2D

var start_pos : Vector2
var end_pos : Vector2

# ===============================================

func _enter_tree():
	var scene_name = get_tree().current_scene.name.to_lower()
	# Change scale based on scene
	if scene_name == "practice":
		scale_basedon_scene = 1
	if scene_name == "1v1":
		scale_basedon_scene = 1.2

func _ready():
	# Manipulate the scale on instantiate
	rocket.scale.x *= scale_basedon_scene
	rocket.scale.y *= scale_basedon_scene
	start_pos = global_position

func _physics_process(delta):
	var direction = transform.x.normalized()
	var collision = move_and_collide(direction * SPEED * delta)

	if collision:
		spawn_explosion()
		queue_free()


func spawn_explosion():
	# Instantiate explosion!!!!!!!!!!
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	end_pos = explosion.global_position
	get_tree().current_scene.add_child(explosion)
	
	# Damage calculation, the damage scales with distance (damage falloff)
	var distance = start_pos.distance_to(end_pos)
	var damage_function = BASE_DAMAGE * pow(DMG_CONSTANT, (distance/500))
	var scaled_damage = clamp(damage_function, MIN_DAMAGE, BASE_DAMAGE)
	explosion.damage = int(scaled_damage)
