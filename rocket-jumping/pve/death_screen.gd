extends Node2D
	
func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
	queue_free()
