@icon("uid://capbagnwe8jn3")
class_name MovementComponent
extends Node

@export var enabled: bool = true
@export var body: CharacterBody2D
@export var speed: float = 300
@export var jump_speed: float = 400
@export var gravity_modifyer: float = 1
## how many seconds until full stop
@export var drag_in_seconds: float = 0:
	set(value):
		drag_in_seconds = value
		_drag_delta = speed / value

var _drag_delta: float = 0
var input_axis: float = 0
var knockback: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	apply_movement_speed(delta)
	body.move_and_slide()
	apply_gravity(delta)


func apply_movement_speed(delta: float) -> void:
	var _internal_velocity: float
	if input_axis != 0:
		_internal_velocity = input_axis * speed
	else:
		_internal_velocity = move_toward(_internal_velocity, 0, _drag_delta * delta)
	body.velocity.x = _internal_velocity + knockback.x


func apply_gravity(delta: float) -> void:
	if body.is_on_floor():
		body.velocity.y = 0
	else:
		var _gracity_acceleration: float = (body.get_gravity().y * gravity_modifyer * delta)
		body.velocity.y += _gracity_acceleration + (knockback.y * delta)


func jump() -> void:
	body.velocity.y = -jump_speed
