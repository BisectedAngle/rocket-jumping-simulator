extends Control


func _on_v_1_pressed() -> void:
	get_tree().change_scene_to_file("res://1v1/1v1.tscn")

func _on_practice_pressed() -> void:
	get_tree().change_scene_to_file("res://practice/practice.tscn")

func _on_pve_pressed() -> void:
	get_tree().change_scene_to_file("res://pve/levels/pve_1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial/tut_1.tscn")
