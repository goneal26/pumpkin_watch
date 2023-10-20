extends Node

var night_counter: int = 1
var pumpkin_counter: int = 0
var current_scene = null
var is_gameover: bool = false

func goto_scene(path: String):
	call_deferred("deferred_goto_scene", path)

func _deferred_goto_scene(path: String):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
