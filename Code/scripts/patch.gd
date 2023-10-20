extends TileMap

@export var pumpkin_spawn_weight: float = 0.1

@onready var ui_label = get_node_or_null("../UI/Label")
@onready var night_timer = get_node_or_null("../DayNightTimer")
@onready var data = get_node("/root/Data")
@onready var raccoon_timer = get_node_or_null("../RaccoonTimer")
@onready var gameover_ui = get_node_or_null("../UI/GameOverUI")
@onready var endofnight_ui = get_node_or_null("../UI/EndOfNightUI")

var creature_present: bool = false

var map_size: Vector2i = Vector2i(36, 20)

const VINE_ATLAS_COORD: Vector2i = Vector2i(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in map_size.x:
		for y in map_size.y:
			if get_cell_atlas_coords(0, Vector2i(x, y)) == VINE_ATLAS_COORD and randf() < pumpkin_spawn_weight:
				data.pumpkin_counter = data.pumpkin_counter + 1
				var pumpkin = load("res://props/pumpkin.tscn")
				var pumpkin_instance = pumpkin.instantiate()
				get_parent().add_child.call_deferred(pumpkin_instance)
				pumpkin_instance.position = map_to_local(Vector2i(x, y))

func update_label(text: String):
	ui_label.set_text(text + "\nNIGHT " + str(data.night_counter))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time = int(night_timer.time_left)
	
	if night_timer.is_stopped():
		remove_enemies()
#	print(time)
	if time == 180:
		update_label("12:00 AM")
	elif time == 150:
		update_label("1:00 AM")
	elif time == 120:
		update_label("2:00 AM")
	elif time == 90:
		update_label("3:00 AM")
	elif time == 60:
		update_label("4:00 AM")
	elif time == 30:
		update_label("5:00 AM")
	elif time == 0:
		update_label("6:00 AM") # jank af but whatever
		
	if data.pumpkin_counter <= 0 or data.player_isdead:
		raccoon_timer.stop()
		night_timer.stop()
		data.is_gameover = true
		# gameover condition
		gameover_ui.visible = true
		if data.player_isdead:
			gameover_ui.death_text()
		else:
			gameover_ui.update_text()

func remove_enemies():
	if get_tree().get_root() != null:
		var children = get_parent().get_children()
		for child in children:
			if child.get_class() == "CharacterBody2D":
				if child.node_name == "enemy":
					child.queue_free()

func _on_raccoon_timer_timeout():
	var directions: Dictionary = {
		0: Vector2.LEFT,
		1: Vector2.RIGHT,
		2: Vector2.UP,
		3: Vector2.DOWN
	}
	
	var direction: Vector2 = directions[randi_range(0, 3)]
	var raccoon = load("res://actors/raccoon.tscn")
	var raccoon_instance = raccoon.instantiate()
	get_parent().add_child.call_deferred(raccoon_instance)
	match(direction):
		Vector2.LEFT:
			raccoon_instance.position = map_to_local(Vector2(26, randi_range(3, 17)))
		Vector2.RIGHT:
			raccoon_instance.position = map_to_local(Vector2(9, randi_range(3, 17)))
		Vector2.UP:
			raccoon_instance.position = map_to_local(Vector2(randi_range(11, 24), 19))
		Vector2.DOWN:
			raccoon_instance.position = map_to_local(Vector2(randi_range(11, 24), 1))
	raccoon_instance.run_direction = direction


func _on_day_night_timer_timeout():
	raccoon_timer.stop()
	remove_enemies()
	data.is_gameover = true # game not actually over, just turning off player movement
	endofnight_ui.visible = true
	endofnight_ui.get_child(3).set_text("End of night " + str(data.night_counter) + ".")

# end of night, continue to next night
func _on_night_continue_pressed():
	endofnight_ui.get_child(10).play()
	endofnight_ui.visible = false
	data.night_counter = data.night_counter + 1
	raccoon_timer.wait_time = raccoon_timer.wait_time / 1.5
	raccoon_timer.start()
	night_timer.start()
	update_label("12:00 AM")
	if creature_present == false and data.pumpkin_counter <= 5:
		creature_present = true
		var creature = load("res://actors/creature.tscn")
		var creature_instance = creature.instantiate()
		get_parent().add_child.call_deferred(creature_instance)
		creature_instance.position = Vector2(288, -93)


func _on_to_main_menu_pressed():
	endofnight_ui.get_child(10).play()
	await endofnight_ui.get_child(10).finished
	data.goto_scene("res://menus/main_menu.tscn")
