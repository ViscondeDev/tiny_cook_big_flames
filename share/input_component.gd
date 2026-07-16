@icon("uid://drb3cti1wslkx")
class_name InputManager
extends Node

signal moved_up
signal updated_mouse_1(pressed: bool)

@export var enabled: bool = true:
	set(value):
		enabled = value
		if not enabled:
			direction = Vector2.ZERO

var direction: Vector2 = Vector2.ZERO
var is_mouse_1_pressed: bool = false:
	set(value):
		updated_mouse_1.emit(value)
		is_mouse_1_pressed = value


func get_directional_inputs() -> float:
	var input_direction: float = Input.get_axis("move_left", "move_right")
	return input_direction


func get_actions() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) != is_mouse_1_pressed:
		is_mouse_1_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if Input.is_action_just_pressed("move_up"):
		moved_up.emit()
