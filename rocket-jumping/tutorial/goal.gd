extends Area2D

# This is an array with all the level names
var level_cycle = ["tut_1","tut_2","tut_3","tut_4","tut_5","tut_6","tut_7","tut_8","tut_9","tut_10","tut_11","tut_12"]

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player1":
		# Find the index of the name of the scene and increment it by 1
		var new_level_index = level_cycle.find(get_tree().get_current_scene().name)+1
		
		if new_level_index != 12:
			# Use string manipulation to put the level in the directory
			get_tree().change_scene_to_file.call_deferred("res://tutorial/"+level_cycle[new_level_index]+".tscn")

		else: # If the level is 12, then go to title screen when player reaches goal
			get_tree().change_scene_to_file.call_deferred("res://title_screen/title_screen.tscn")
