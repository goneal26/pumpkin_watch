extends CharacterBody2D

@onready var movement_validation: RayCast2D = $MovementValidation
@onready var movement_tween: Node = $MovementTween
@onready var flashlight: RayCast2D = $Flashlight
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var data = get_node("/root/Data")
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var grid_size: int = 16

var direction: Vector2 = Vector2.ZERO
var can_move: bool = true

func _ready():
	sprite.play("front")

func _process(_delta: float):
	if data.pumpkin_counter <= 0: # player shouldn't move after gameover
		can_move = false
#	direction.x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
#	direction.y = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
	if Input.is_action_pressed("left"):
		sprite.flip_h = true
		sprite.play("side")
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		sprite.flip_h = false
		sprite.play("side")
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("down"):
		sprite.play("front")
		direction = Vector2.DOWN
	elif Input.is_action_pressed("up"):
		sprite.play("back")
		direction = Vector2.UP

func _physics_process(_delta: float):
	if movement_validation.validate_movement(direction * grid_size) and can_move and direction != Vector2.ZERO:
		can_move = false
		movement_tween.run(self, global_position + direction * grid_size)
		sound.play()
		movement_tween.tween.finished.connect(on_movement_tween_finished)

func on_movement_tween_finished():
	can_move = true
	direction = Vector2.ZERO
