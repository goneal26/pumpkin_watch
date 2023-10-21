extends Node2D

@onready var nights_label := $NightsLabel
@onready var sound := $AudioStreamPlayer2D
@onready var data = get_node("/root/Data")

func update_text():
	nights_label.set_text("YOUR PUMPKIN PATCH SURVIVED " + str(data.night_counter) + " NIGHTS.")

func death_text():
	nights_label.set_text("SOMETHING DRAGS YOU AWAY.")

func _ready():
	nights_label.set_text("YOUR PUMPKIN PATCH SURVIVED " + str(data.night_counter) + " NIGHTS.")


func _on_to_main_menu_pressed():
	sound.play()
	data.is_paused = false
	await sound.finished
	data.goto_scene("res://menus/main_menu.tscn")
