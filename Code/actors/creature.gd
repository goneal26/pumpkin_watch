extends CharacterBody2D

var node_name: String = "creature"
@export var speed: int = 10
var can_move: bool = true
var direction: Vector2 = Vector2.ZERO
@onready var player: CharacterBody2D = get_node_or_null("../Player")
@onready var data = get_node("/root/Data")
@onready var sprite := $AnimatedSprite2D
@onready var collider := $CollisionShape2D
@onready var sound := $AudioStreamPlayer2D

func _ready():
	sprite.frame = 1

func _physics_process(_delta):
	if can_move and player != null:
		sound.playing = true
		sprite.frame = 1
		direction = position.direction_to(player.position)
		if direction.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		velocity = direction * speed
		move_and_slide()
	else:
		sound.playing = false
		sprite.frame = 0


func _on_area_2d_body_entered(body):
	if body == player:
		data.player_isdead = true
		print("gotcha")
