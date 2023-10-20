extends Node2D

@onready var data = get_node("/root/Data")
@onready var sound := $AudioStreamPlayer2D

func _on_back_pressed():
	sound.play()
	await sound.finished
	data.goto_scene("res://menus/main_menu.tscn")
