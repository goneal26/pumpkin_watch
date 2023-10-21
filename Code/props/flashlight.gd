extends RayCast2D

@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var data = get_node("/root/Data")
@onready var creature = get_node_or_null("../../Creature")
@onready var sound2: AudioStreamPlayer2D = $Sound2

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
			data.flashlight_on = true
			if !sound.playing:
				sound.play()
		else:
			data.flashlight_on = false

func _physics_process(_delta):
	if visible == true and is_colliding():
		var object = get_collider()
		if object != null and object.get_class() == "CharacterBody2D":
			if object.node_name == "creature":
				data.creature_canmove = false
			elif object.node_name == "enemy":
					object.get_scared()
	else:
		data.creature_canmove = true
#			if object.node_name == "enemy":
#				object.get_scared()
#			elif object.node_name == "creature":
#				# stop moving only if raycast colliding
#				pass
