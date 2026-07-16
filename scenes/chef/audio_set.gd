@icon("res://addons/at-icons/node2d/note.svg")
class_name ChefAudioSet
extends Node

@export var jump_sounds: Array[AudioStreamPlayer2D]
@export var walk_sounds: Array[AudioStreamPlayer2D]

var is_walking: bool = false
var current_walking_stream: AudioStreamPlayer2D


func _physics_process(delta: float) -> void:
	if not current_walking_stream == null:
		if not current_walking_stream.playing and is_walking:
			_play_walk()


func jump() -> void:
	randomize()
	var sound: = jump_sounds[randi() % jump_sounds.size()]
	sound.play()


func _play_walk() -> void:
	randomize()
	var sound: = jump_sounds[randi() % jump_sounds.size()]
	sound.play()
	current_walking_stream = sound
