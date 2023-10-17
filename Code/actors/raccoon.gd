extends CharacterBody2D

@onready var movement_validation: RayCast2D = $MovementValidation
@onready var movement_tween: Node = $MovementTween
@onready var sprite: Sprite2D = $Sprite2D
@onready var eyes: PointLight2D = $Sprite2D/PointLight2D

@export var grid_size : int = 16

var run_direction: Vector2 
var direction: Vector2 = Vector2.ZERO
var can_move: bool = true
var is_scared: bool = false

func get_scared():
	if is_scared == false:
		is_scared = true
		run_direction = -run_direction
		if run_direction.x < 0:
			flip(true)
		else:
			flip(false)
		print("is scared", is_scared)
	else:
		pass

func _ready():
	direction = run_direction
	if run_direction.x < 0:
		flip(true)
	else:
		flip(false)

func flip(is_flipped: bool):
	if is_flipped:
		sprite.flip_h = true
		eyes.texture = load("res://assets/enemy_eyes_flipped.png")
	else: 
		sprite.flip_h = false
		eyes.texture = load("res://assets/enemy_eyes.png")
# this code puts out a really weird c++ error, dont know what it means but it doesn't break anything

func _process(_delta):
	if position.x > 425 or position.x < 152 or position.y < 26 or position.y > 315:
		self.queue_free()
		print("deleted")

func _physics_process(_delta: float):
	direction = run_direction
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