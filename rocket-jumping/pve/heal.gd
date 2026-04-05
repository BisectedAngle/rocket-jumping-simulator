extends Area2D

func _on_body_entered(body):
	if body.has_method("heal"): # Check if the node entering it is player (only one with heal function)
		if body.health < body.MAX_HEALTH: # Only will heal when health is less than max health
			get_parent().healing_exist = false # Update boolean tracker of presence of health pack
			get_parent().healing_used += 1
			body.heal(20) # Heal for 20 HP
			queue_free()
