@icon("res://addons/at-icons/node2d/note.svg")
class_name ChefAudioSet
extends Node2D

@export var jump_sounds: Array[AudioStreamPlayer2D]
@export var walk_sounds: Array[AudioStreamPlayer2D]
@export var landing_sounds: Array[AudioStreamPlayer2D]

var is_walking: bool = false
var current_walking_stream: AudioStreamPlayer2D


func _physics_process(_delta: float) -> void:
	if is_walking:
		if current_walking_stream == null or not current_walking_stream.playing:
			_play_walk()


func jump() -> void:
	randomize()
	var sound: = jump_sounds[randi() % jump_sounds.size()]
	sound.play()


func _play_land() -> void:
	randomize()
	var sound: = landing_sounds[randi() % landing_sounds.size()]
	sound.play()


func _play_walk() -> void:
	randomize()
	var sound: = walk_sounds[randi() % walk_sounds.size()]
	sound.play()
	current_walking_stream = sound
