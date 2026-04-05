extends Area2D

# This node appears sometimes in the tutorial

func _on_body_entered(body: Node2D) -> void:
	
	# If the player falls in this area, teleport it to a place with solid ground (hard coded)
	if body.name == "player1":
		body.global_position = Vector2(155,160)
