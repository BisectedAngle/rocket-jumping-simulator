# PLEASE OBSERVE PVE_1 FOR ALL COMMENTS, 
# ALL LEVELS HAVE PRACTICALLY THE SAME CODE, ONLY PARAMETERS ARE CHANGED

extends Node2D

@onready var win_scene := preload("res://pve/pve_win_screen.tscn")

@export var max_walkers = 4
@export var max_jumpers = 4
@export var walker_goal = 7
@export var jumper_goal = 7

var healing_positions = [Vector2(137,138), Vector2(1800,138), Vector2(1800,664), Vector2(137,664)]
var healing_exist = false 
var healing_used = 0
@onready var healing_scene := preload("res://pve/heal.tscn")
@onready var heal_timer := $heal_timer

var walkers = 0
var walkers_killed = 0
@onready var walker_scene := preload("res://pve/enemies/walker.tscn")
@onready var walker_timer := $walker_timer
@onready var walker_progress := $walker_progress
@onready var walker_label := $walker_progress/walker_label

var jumpers = 0
var jumpers_killed = 0
@onready var jumper_scene := preload("res://pve/enemies/jumper.tscn")
@onready var jumper_timer := $jumper_timer
@onready var jumper_progress := $jumper_progress
@onready var jumper_label := $jumper_progress/jumper_label

var elapsed_time = 0.0
var minutes = 0
var seconds = 0
@onready var level_timer := $level_timer

@onready var player := $player1

# ===================================================

func _ready():
	level_timer.start()
	heal_timer.start()
	walker_progress.max_value = walker_goal
	jumper_progress.max_value = jumper_goal

func _process(delta: float) -> void:
	elapsed_time += delta
	
	if(walkers==0):
		spawn_walker()
		walker_timer.start()
		
	if(jumpers==0):
		spawn_jumper()
		jumper_timer.start()
		
	if(walkers==max_walkers):
		walker_timer.stop()
	
	if(jumpers==max_jumpers):
		jumper_timer.stop()
	
	if(walkers_killed>=walker_goal and jumpers_killed>=jumper_goal):
		level_timer.stop()
		
		Global.total_time_taken += elapsed_time
		minutes = int(elapsed_time / 60)
		seconds = int(elapsed_time - (minutes * 60))
		spawn_win_screen()
	
	update_bars()

#====================================================================

func spawn_walker():
	walkers += 1
	var walker = walker_scene.instantiate()
	walker.global_position = Vector2(200,20)
	get_tree().current_scene.add_child(walker)

func spawn_jumper():
	jumpers += 1
	var jumper = jumper_scene.instantiate()
	jumper.global_position = Vector2(1700,20)
	get_tree().current_scene.add_child(jumper)

func _on_walker_timer_timeout() -> void:
	spawn_walker()
	walker_timer.start()

func _on_jumper_timer_timeout() -> void:
	spawn_jumper()
	jumper_timer.start()

func update_bars():
	walker_progress.value = walkers_killed
	jumper_progress.value = jumpers_killed
	
	if walkers_killed > walker_goal:
		walker_label.text = str(walker_goal) + "/" + str(walker_goal)
	else: 
		walker_label.text = str(walkers_killed) + "/" + str(walker_goal)
		
	if jumpers_killed > jumper_goal:
		jumper_label.text = str(jumper_goal) + "/" + str(jumper_goal)
	else:
		jumper_label.text = str(jumpers_killed) + "/" + str(jumper_goal)

func spawn_healing():
	if !healing_exist:
		healing_exist = true
		var healing = healing_scene.instantiate()
		healing.global_position = healing_positions.pick_random()
		get_tree().current_scene.add_child(healing)

func _on_heal_timer_timeout() -> void:
	spawn_healing()
	heal_timer.start()

func spawn_win_screen():
	var win_screen = win_scene.instantiate()
	win_screen.global_position = Vector2(960,540)
	get_tree().current_scene.add_child(win_screen)
	
	win_screen.walkers_killed.text = str(walkers_killed)
	win_screen.jumpers_killed.text = str(jumpers_killed)
	win_screen.healing_used.text = str(healing_used)
	win_screen.time_taken.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
	win_screen.rockets_shot.text = str(player.rocket_launcher.rocket_counter)
	
	Global.total_walkers_killed += walkers_killed
	Global.total_jumpers_killed += jumpers_killed
	Global.total_healing_used += healing_used
	Global.total_rockets_shot += player.rocket_launcher.rocket_counter
	
	get_tree().paused = true
	
	
