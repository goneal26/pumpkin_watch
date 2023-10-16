extends CharacterBody2D

@onready var movement_validation: RayCast2D = $MovementValidation
@onready var movement_tween: Node = $MovementTween
@onready var sprite: Sprite2D = $Sprite2D

@export var grid_size : int = 32

var run_direction: Vector2 
var direction: Vector2 = Vector2.ZERO
var can_move: bool = true
var is_scared: bool = false

func get_scared():
	if is_scared == false:
		is_scared = true
		run_direction = -run_direction
		print("is scared", is_scared)
	else:
		pass

func _process(_delta):
	if position.x < 0 or position.y < 0 or position.x > get_viewport_rect().size.x or position.y > get_viewport_rect().size.y:
		self.queue_free()
		print("deleted")

func _physics_process(_delta: float):
	direction = run_direction
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if movement_validation.is_colliding():
		var pumpkin = movement_validation.get_collider()
		if pumpkin != null and pumpkin.get_class() == "StaticBody2D":
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
