extends Node

var night_counter: int = 1
var pumpkin_counter: int = 0
var current_scene = null
var is_gameover: bool = false
var flashlight_on: bool = false
var player_isdead: bool = false
var creature_canmove: bool = false
var is_paused: bool = false

func goto_scene(path: String):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
	get_tree().change_scene_to_file(path)
