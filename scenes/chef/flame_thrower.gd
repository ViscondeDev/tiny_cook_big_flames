@icon("res://addons/at-icons/node2d/fire.svg")
class_name FlameThrower
extends Node2D

@onready var ray: RayCast2D = %RayCast2D
@export var particles: GPUParticles2D
@export var body: Chef
@export var knockback_force: float = 300
@export var max_knockback: Vector2 = Vector2(50, 50)

var firing: bool = false:
	set(value):
		if value:
			particles.emitting = true
		else:
			particles.emitting = false
			body.apply_knockback(Vector2.ZERO)
		firing = value


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

	if firing:
		body.apply_knockback(_calculate_knockback())
		_detect_igredient()


func _detect_igredient() -> void:
	var collision_point: Vector2 = ray.get_collision_point()
	if collision_point != Vector2.ZERO:
		var target: Igredient = ray.get_collider()
		if target is Igredient:
			target.paint(collision_point)


func _calculate_knockback() -> Vector2:
	var knockback := (Vector2(knockback_force, 0).rotated(rotation) * -1)
	knockback.x = clampf(knockback.x, max_knockback.x * -1, max_knockback.x)
	knockback.y = clampf(knockback.y, max_knockback.y * -1, max_knockback.y)
	return knockback


func _update_state(fire: bool) -> void:
	firing = fire
