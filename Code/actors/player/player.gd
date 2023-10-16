extends CharacterBody2D

@onready var movement_validation: RayCast2D = $MovementValidation
@onready var movement_tween: Node = $MovementTween

@export var grid_size: int = 32

var direction: Vector2 = Vector2.ZERO
var can_move: bool = true

func _process(delta: float):
#	direction.x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
#	direction.y = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
	if Input.is_action_pressed("left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("up"):
		direction = Vector2.UP


func _physics_process(delta: float):
	if movement_validation.validate_movement(direction * grid_size) and can_move and direction != Vector2.ZERO:
		can_move = false
		movement_tween.run(self, global_position + direction * grid_size)
		movement_tween.tween.finished.connect(on_movement_tween_finished)

func on_movement_tween_finished():
	can_move = true
	direction = Vector2.ZERO
