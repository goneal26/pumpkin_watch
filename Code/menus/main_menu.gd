extends Node2D

@onready var data = get_node("/root/Data")
@onready var sound := $AudioStreamPlayer2D

func _on_play_pressed():
	data.night_counter = 1
	data.pumpkin_counter = 0
	data.is_gameover = false
	data.flashlight_on = false
	data.player_isdead = false
	data.creature_canmove = false
	data.is_paused = false
	sound.play()
	await sound.finished
	data.goto_scene("res://scenes/pumpkin_patch.tscn")


func _on_how_to_play_pressed():
	sound.play()
	await sound.finished
	data.goto_scene("res://menus/how_to_play.tscn")
