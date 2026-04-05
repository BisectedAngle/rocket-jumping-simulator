extends Node2D

@onready var walkers_killed = $walkers_killed
@onready var jumpers_killed = $jumpers_killed
@onready var time_taken = $time_taken
@onready var healing_used = $healing_used
@onready var rockets_shot = $rockets_shot

func _ready() -> void:
	
	# Converting elapsed time in seconds to minutes and remaining seconds
	var minutes = int(Global.total_time_taken / 60)
	var seconds = int(Global.total_time_taken - (minutes * 60))
	
	walkers_killed.text = str(Global.total_walkers_killed)
	jumpers_killed.text = str(Global.total_jumpers_killed)
	healing_used.text = str(Global.total_healing_used)
	time_taken.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
	rockets_shot.text = str(Global.total_rockets_shot)
