extends Control

# Hide when the scene begins
func _ready():
	hide()

func pause():
	# Show the pause menu and pause the scene
	show()
	get_tree().paused = true

func _on_resume_pressed() -> void:
	# Unpause the scene then hide the pause menu
	get_tree().paused = false
	hide()

func _on_restart_pressed() -> void:
	# Unpause the scene and then reload it
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	# Unpause the scene then go back to title screen
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		pause()
		
	# Make sure it always instantiates at the top level
	self.z_index = 1
