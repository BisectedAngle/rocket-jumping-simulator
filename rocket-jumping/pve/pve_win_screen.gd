extends Node2D

# These are all the stats to display, they are obtained from various
# scenes and will all be updated in the main pve level scene
@onready var walkers_killed = $walkers_killed
@onready var jumpers_killed = $jumpers_killed
@onready var time_taken = $time_taken
@onready var healing_used = $healing_used
@onready var rockets_shot = $rockets_shot

# =================================================

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  
		next_level()
	if Input.is_action_just_pressed("ui_cancel"):
		replay()
		
func replay():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func next_level():
	get_tree().paused = false
	# Using string manipulation to get directory name
	get_tree().change_scene_to_file("res://pve/levels/"+get_cycle_index()+".tscn")
	queue_free()
	
# This is to get the name of the subsequent level
func get_cycle_index():
	if get_parent().name == "pve_1":
		return "pve_2"
	if get_parent().name == "pve_2":
		return "pve_3"
	if get_parent().name == "pve_3":
		return "pve_4"
	if get_parent().name == "pve_4":
		return "you_win"
