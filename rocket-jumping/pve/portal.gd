extends Area2D

# Can change the portal to be one-way
@export var enterable = true
@onready var destination = $Marker2D

func _on_body_entered(body: Node2D) -> void:
	if enterable:
		if not body.is_in_group("rockets"):
			# Teleport the body to the marker position (if its not a rocket)
			body.set_position(destination.global_position)
