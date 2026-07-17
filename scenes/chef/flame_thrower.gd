@icon("res://addons/at-icons/node2d/fire.svg")
class_name FlameThrower
extends Node2D

const NOISE1_SPEED = 750.0
const NOISE2_SPEED = 500.0
const FIRE_SPEED = 0.5
@onready var flame_rect: ColorRect = %ColorRect
@onready var ray: RayCast2D = %RayCast2D
@onready var torch: Sprite2D = %Torch
@onready var hands: Sprite2D = %Hands
@export var particles: GPUParticles2D
@export var body: Chef
@export var knockback_force: float = 300
@export var max_knockback: Vector2 = Vector2(50, 50)

@export_category("sounds")
@export var cast:AudioStreamPlayer2D
@export var hold:AudioStreamPlayer2D
@export var release:AudioStreamPlayer2D

@onready var mat: ShaderMaterial = flame_rect.material
@onready var noise1: NoiseTexture2D = mat.get_shader_parameter("noise1_texture")
@onready var noise2: NoiseTexture2D = mat.get_shader_parameter("noise2_texture")

var fire_val: float = 0.0
var fire_tween: Tween

var target: Ingredient

var firing: bool = false:
	set(value):
		if value:
			_start_flame()
			cast.play()
		else:
			_stop_flame()
			release.play()
			hold.stop()
			body.apply_knockback(Vector2.ZERO)
			if target != null:
				target.apply_knockback(Vector2.ZERO)
		firing = value


func _tween_parameter(value: float, parameter: String) -> void:
	mat.set_shader_parameter(parameter, value)


func _reset_offsets() -> void:
	@warning_ignore("unsafe_property_access")
	noise1.noise.offset.x = 0
	@warning_ignore("unsafe_property_access")
	noise2.noise.offset.x = 0


func _start_flame() -> void:
	_reset_offsets()
	mat.set_shader_parameter("clean_progress", 0.0)
	if fire_tween:
		fire_tween.kill()

	fire_tween = create_tween()
	fire_tween.tween_method(
		_tween_parameter.bind("fire_progress"),
		0.0,
		1.0,
		0.25,
	).set_trans(Tween.TRANS_CUBIC)
	particles.emitting = true


func _stop_flame() -> void:
	if fire_tween:
		fire_tween.kill()

	fire_tween = create_tween()
	fire_tween.tween_method(
		_tween_parameter.bind("clean_progress"),
		0.0,
		1.0,
		0.25,
	).set_trans(Tween.TRANS_CUBIC)
	particles.emitting = false


func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	torch.flip_v = body.global_position < ray.global_position
	hands.flip_v = body.global_position < ray.global_position

	@warning_ignore("unsafe_property_access")
	noise1.noise.offset.x -= delta * NOISE1_SPEED
	@warning_ignore("unsafe_property_access")
	noise2.noise.offset.x -= delta * NOISE2_SPEED

	if firing:
		body.apply_knockback(_calculate_knockback())
		_detect_igredient()
		if not hold.playing:
			hold.play()



func _detect_igredient() -> void:
	var collision_point: Vector2 = ray.get_collision_point()
	if collision_point != Vector2.ZERO:
		if ray.get_collider() is Ingredient:
			target = ray.get_collider()
			target.paint(collision_point)
			target.apply_knockback(_calculate_knockback() * -2)


func _calculate_knockback() -> Vector2:
	var knockback := (Vector2(knockback_force, 0).rotated(rotation) * -1)
	knockback.x = clampf(knockback.x, max_knockback.x * -1, max_knockback.x)
	knockback.y = clampf(knockback.y, max_knockback.y * -1, max_knockback.y)
	return knockback


func _update_state(fire: bool) -> void:
	firing = fire
