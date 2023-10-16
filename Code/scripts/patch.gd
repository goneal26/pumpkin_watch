extends TileMap

@export var pumpkin_spawn_weight: float = 0.1

var map_size: Vector2i = Vector2i(36, 20)

const VINE_ATLAS_COORD: Vector2i = Vector2i(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in map_size.x:
		for y in map_size.y:
			if get_cell_atlas_coords(0, Vector2i(x, y)) == VINE_ATLAS_COORD and randf() < pumpkin_spawn_weight:
				var pumpkin = load("res://props/pumpkin.tscn")
				var pumpkin_instance = pumpkin.instantiate()
				get_parent().add_child.call_deferred(pumpkin_instance)
				pumpkin_instance.position = map_to_local(Vector2i(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
