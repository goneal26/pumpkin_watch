extends CharacterBody2D

@onready var movement_validation: RayCast2D = $MovementValidation
@onready var movement_tween: Node = $MovementTween
@onready var sprite: Sprite2D = $Sprite2D
@onready var eyes: PointLight2D = $Sprite2D/PointLight2D
@onready var data = get_node("/root/Data")
@onready var step_sound: AudioStreamPlayer2D = $StepPlayer
@onready var eat_sound: AudioStreamPlayer2D = $EatPlayer
@onready var scare_sound: AudioStreamPlayer2D = $ScarePlayer
@export var grid_size : int = 16

const node_name = "enemy"
var run_direction: Vector2 
var direction: Vector2 = Vector2.ZERO
var can_move: bool = true
var is_scared: bool = false

func get_scared():
	if is_scared == false:
		scare_sound.play()
		is_scared = true
		run_direction = -run_direction
		if run_direction.x < 0:
			flip(true)
		else:
			flip(false)

func _ready():
	direction = run_direction
	if run_direction.x < 0:
		flip(true)
	else:
		flip(false)

func flip(is_flipped: bool):
	if is_flipped:
		sprite.flip_h = true
		eyes.offset = Vector2(-9, 0)
#		eyes.texture = load("res://assets/enemy_eyes_flipped.png")
	else: 
		sprite.flip_h = false
		eyes.offset = Vector2.ZERO
#		eyes.texture = load("res://assets/enemy_eyes.png")
# this code puts out a really weird c++ error, dont know what it means but it doesn't break anything

func _process(_delta):
	if position.x > 440 or position.x < 121 or position.y < 9 or position.y > 332:
		self.queue_free()

func _physics_process(_delta: float):
	direction = run_direction
	if movement_validation.is_colliding():
		var pumpkin = movement_validation.get_collider()
		if pumpkin != null and pumpkin.get_class() == "StaticBody2D":
			if pumpkin.health <= 0:
				eat_sound.play()
				pumpkin.queue_free()
				data.pumpkin_counter = data.pumpkin_counter - 1
			else:
				pumpkin.health = pumpkin.health - 1
	if movement_validation.validate_movement(direction * grid_size) and can_move and direction != Vector2.ZERO and !data.is_paused:
		can_move = false
		movement_tween.run(self, global_position + direction * grid_size)
		step_sound.play()
		movement_tween.tween.finished.connect(on_movement_tween_finished)

func on_movement_tween_finished():
	can_move = true
	direction = Vector2.ZERO
