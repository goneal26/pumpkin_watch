extends RayCast2D

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

func _physics_process(_delta):
	if is_colliding():
		var raccoon = get_collider()
		if raccoon != null and raccoon.get_class() == "CharacterBody2D":
			raccoon.get_scared()
