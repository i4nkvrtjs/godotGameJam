extends Node3D

@onready var animalLog: Control = $"../Log"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("toggleLog"):
		animalLog.toggle_log()
	elif event.is_action_pressed("logNext"):
		animalLog.next_animal()
