extends RayCast2D

@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

const INPUTS: Dictionary = {
	"light_down": 0,
	"light_right": 270,
	"light_left": 90,
	"light_up": 180
}

func _process(_delta):
	if Input.is_action_pressed("light_down"):
		visible = true
		rotation_degrees = 0
	elif Input.is_action_pressed("light_right"):
		visible = true
		rotation_degrees = 270
	elif Input.is_action_pressed("light_left"):
		visible = true
		rotation_degrees = 90
	elif Input.is_action_pressed("light_up"):
		visible = true
		rotation_degrees = 180
	else:
		visible = false
	
	for dir in INPUTS.keys():
		if Input.is_action_just_pressed(dir):
			if !sound.playing:
				sound.play()

func _physics_process(_delta):
	if visible == true and is_colliding():
		var raccoon = get_collider()
		if raccoon != null and raccoon.get_class() == "CharacterBody2D":
			raccoon.get_scared()
