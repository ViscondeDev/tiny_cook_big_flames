@icon("res://addons/at-icons/node2d/poultry.svg")
class_name Ingredient
extends CharacterBody2D

@export var sprite: Sprite2D
@export var cook_radius: int = 50
@export var movement_manager: MovementComponent
@export var burn_treshold: float = 0.4

var pixels_in_image: int
var cooked_percentage: float:
	get():
		var percentage := float(_count_pixels_on_treshold()) * 100 / float(pixels_in_image)
		return percentage
var heatmap: Image


func _ready() -> void:
	create_new_heatmap()


func create_new_heatmap() -> void:
	var new_heatmap: Image = sprite.texture.get_image()
	var width: int = new_heatmap.get_width()
	var height: float = new_heatmap.get_height()

	for y in height:
		for x in width:
			var color: Color = new_heatmap.get_pixel(x, y)
			if color.a > 0:
				new_heatmap.set_pixel(x, y, Color.WHITE)
				pixels_in_image += 1
	heatmap = new_heatmap


func paint(point: Vector2) -> void:
	var collision_point: Vector2 = point - global_position

	var _boundarie_top_left := collision_point - Vector2(cook_radius, cook_radius)
	var _boundarie_bottom_right := collision_point + Vector2(cook_radius, cook_radius)

	var image: Image = sprite.texture.get_image()
	var width: int = image.get_width()
	var height: float = image.get_height()

	for y in range(_boundarie_top_left.y, _boundarie_bottom_right.y):
		if y < 0 or y > height - 1:
			continue
		for x in range(_boundarie_top_left.x, _boundarie_bottom_right.x):
			if x < 0 or x > width - 1:
				continue
			var display_color: Color = image.get_pixel(x, y)
			var heatmap_color: Color = heatmap.get_pixel(x, y)

			if display_color.a > 0:
				display_color.r += 0.01
				image.set_pixel(x, y, display_color)
				heatmap_color.v -= 0.01
				heatmap.set_pixel(x, y, heatmap_color)

	sprite.texture = ImageTexture.create_from_image(image)


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
