extends CharacterBody2D

@onready var movement_validation: RayCast2D = $MovementValidation
@onready var movement_tween: Node = $MovementTween

@export var grid_size : int = 32

var direction: Vector2 = Vector2.ZERO
var can_move: bool = true

func _physics_process(_delta: float):
	direction = Vector2.RIGHT
	if movement_validation.is_colliding():
		var pumpkin = movement_validation.get_collider()
		if pumpkin != null:
			if pumpkin.health <= 0:
				pumpkin.queue_free()
			else:
				pumpkin.health = pumpkin.health - 1
	if movement_validation.validate_movement(direction * grid_size) and can_move and direction != Vector2.ZERO:
		can_move = false
		movement_tween.run(self, global_position + direction * grid_size)
		movement_tween.tween.finished.connect(on_movement_tween_finished)

func on_movement_tween_finished():
	can_move = true
	direction = Vector2.ZERO
