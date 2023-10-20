extends Node2D

@onready var data = get_node("/root/Data")
@onready var sound := $AudioStreamPlayer2D

func _on_play_pressed():
	sound.play()
	await sound.finished
	data.goto_scene("res://scenes/pumpkin_patch.tscn")


func _on_how_to_play_pressed():
	sound.play()
	await sound.finished
	data.goto_scene("res://menus/how_to_play.tscn")
