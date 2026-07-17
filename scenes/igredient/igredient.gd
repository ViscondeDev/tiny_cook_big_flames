@icon("res://addons/at-icons/node2d/poultry.svg")
class_name Ingredient
extends CharacterBody2D

@export var image: ColorRect
@export var cook_radius: int = 50
@export var movement_manager: MovementComponent
@export var burn_treshold: float = 0.4
@export var audio: AudioStreamPlayer2D
@onready var mat: ShaderMaterial = image.material

var pixels_in_image: int
var cooked_percentage: float:
	get():
		var percentage := float(_count_pixels_on_treshold()) * 100 / float(pixels_in_image)
		return percentage
var heatmap: Image


func _ready() -> void:
	create_new_heatmap()

var image_width: int
var image_height: int
func create_new_heatmap() -> void:
	var texture: Texture2D = mat.get_shader_parameter("image_texture")
	var new_heatmap: Image = texture.get_image()
	image_width = int(new_heatmap.get_width())
	image_height = int(new_heatmap.get_height())

	for y in image_height:
		for x in image_width:
			var color: Color = new_heatmap.get_pixel(x, y)
			if color.a > 0:
				new_heatmap.set_pixel(x, y, Color.WHITE)
				pixels_in_image += 1
	heatmap = new_heatmap
	
	var heatmap_texture: Texture2D = ImageTexture.create_from_image(heatmap)
	mat.set_shader_parameter("heatmap_texture", heatmap_texture)

func paint(point: Vector2) -> void:
	if not audio.playing:
		audio.play()

	var collision_point: Vector2 = point - global_position

func _internal_paint(collision_point: Vector2) -> void:
	var _boundarie_top_left := collision_point - Vector2(cook_radius, cook_radius)
	var _boundarie_bottom_right := collision_point + Vector2(cook_radius, cook_radius)

	for y in range(_boundarie_top_left.y, _boundarie_bottom_right.y):
		if y < 0 or y > image_height - 1:
			continue
		for x in range(_boundarie_top_left.x, _boundarie_bottom_right.x):
			if x < 0 or x > image_width - 1:
				continue
			var heatmap_color: Color = heatmap.get_pixel(x, y)

			if heatmap_color.a > 0:
				heatmap_color.r -= 0.01
				heatmap_color.g -= 0.01
				heatmap_color.b -= 0.01
				heatmap.set_pixel(x, y, heatmap_color)
	
	_update_image.call_deferred()


func _update_image() -> void:
	var heatmap_texture: Texture2D = ImageTexture.create_from_image(heatmap)
	mat.set_shader_parameter("heatmap_texture", heatmap_texture)


func paint(point: Vector2) -> void:
	var collision_point: Vector2 = point - global_position
	WorkerThreadPool.add_task(_internal_paint.bind(collision_point))


func apply_knockback(force: Vector2) -> void:
	movement_manager.knockback = force


func _count_pixels_on_treshold() -> int:
	var cooked_count := 0

	var width: int = heatmap.get_width()
	var height: int = heatmap.get_height()
	for y in height:
		for x in width:
			var color: Color = heatmap.get_pixel(x, y)
			if color.a > 0:
				if 1 - color.v > burn_treshold:
					cooked_count += 1
	print("cooked: ", cooked_count, " total :", pixels_in_image)
	return cooked_count
