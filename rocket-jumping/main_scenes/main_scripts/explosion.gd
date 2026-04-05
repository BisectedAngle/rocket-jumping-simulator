extends Area2D

var knockback_force = 700
var scale_basedon_scene = Vector2(0.3, 0.3)
var affected_bodies = {} # Dictionary to remember the bodies affected by knockback
var damage := 0

@onready var explosion_appearance = $Sprite2D
@onready var fadeout_timer = $Timer

# ===========================================================

func _enter_tree():
	var scene_name = get_tree().current_scene.name.to_lower()
	
	# Changing scale of the explosion depending on scene
	if scene_name == "practice":
		scale_basedon_scene = Vector2(0.2, 0.2)
		knockback_force = 500
	if scene_name == "1v1":
		scale_basedon_scene = Vector2(0.25, 0.25)
		knockback_force = 600

func _ready():
	explosion_appearance.scale = scale_basedon_scene
	explosion_appearance.modulate.a = 1.0 # Beginning alpha (opacity) of the explosion
	
	# Tween the explosion appearance so it fades out over 0.5s
	var tween := create_tween()
	tween.tween_property(explosion_appearance, "modulate:a", 0.0, 0.5)
	
	fadeout_timer.start() # The timer is 0.5s which matches the explosion fadeout
	fadeout_timer.connect("timeout", _on_timer_timeout)
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body in affected_bodies:
		return  # If the body is already knocked back, remove to prevent duplicate knockback
	affected_bodies[body] = true # Mark that a specific body has been knocked back
	
	if body.has_method("get_knockback"): # Check if the affected body is knockbackable
		var direction = (body.global_position - global_position).normalized() 
		body.get_knockback(direction * knockback_force) # Call that knockback function
	
	if body.has_method("take_rocket_damage"):
		body.take_rocket_damage(damage,global_position)
	
func _on_timer_timeout():
	queue_free()	# Remove explosion when timer is over
