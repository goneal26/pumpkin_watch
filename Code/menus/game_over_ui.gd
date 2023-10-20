extends Node2D

@onready var nights_label := $NightsLabel
@onready var data = get_node("/root/Data")

func update_text():
	nights_label.set_text("YOUR PUMPKIN PATCH SURVIVED " + str(data.night_counter) + " NIGHTS.")

func _ready():
	nights_label.set_text("YOUR PUMPKIN PATCH SURVIVED " + str(data.night_counter) + " NIGHTS.")
