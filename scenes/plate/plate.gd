extends Area2D

@onready var label: Label = %Label
@export var apple_demmand: int = 2
@export var audio: AudioStreamPlayer2D
@export var apples: int = 0:
	set(v):
		apples = v
		label.text = str("apples: ", apples, "/", apple_demmand)


func _on_body_entered(body: Node2D) -> void:
	print("entered")
	if body is Ingredient:
		audio.play()
		apples += 1
		if not body.cooked_percentage > 60:
			label.text = "Not cooked enough. Take out and try again"


func _on_body_exited(body: Node2D) -> void:
	if body is Ingredient:
		apples -= 1
