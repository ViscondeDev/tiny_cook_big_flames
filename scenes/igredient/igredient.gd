@icon("res://addons/at-icons/node2d/poultry.svg")
class_name Igredient
extends StaticBody2D

@export var sprite: Sprite2D
@export var cook_radius: int = 50


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
			var color: Color = image.get_pixel(x, y)

			if color.a > 0.0:
				image.set_pixel(x, y, Color.RED)

	sprite.texture = ImageTexture.create_from_image(image)
