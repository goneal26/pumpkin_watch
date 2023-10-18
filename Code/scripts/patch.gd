extends TileMap

@export var pumpkin_spawn_weight: float = 0.1

@onready var ui_label = get_node_or_null("../TimeUI/Label")
@onready var night_timer = get_node_or_null("../DayNightTimer")
@onready var data = get_node("/root/Data")
@onready var raccoon_timer = get_node_or_null("../RaccoonTimer")

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
	ui_label.set_text(text + "\nNight " + str(data.night_counter))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time = int(night_timer.time_left)
#	print(time)
	if time == 360:
		update_label("12:00 AM")
	elif time == 300:
		update_label("1:00 AM")
	elif time == 240:
		update_label("2:00 AM")
	elif time == 180:
		update_label("3:00 AM")
	elif time == 120:
		update_label("4:00 AM")
	elif time == 60:
		update_label("5:00 AM")
	elif time == 0:
		update_label("6:00 AM") # jank af but whatever
		
	if data.pumpkin_counter == 0:
		raccoon_timer.stop()
		night_timer.stop()
		data.is_gameover = true
		# gameover condition

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
	data.night_counter += 1
	raccoon_timer.stop()
	# end of night condition goes here
