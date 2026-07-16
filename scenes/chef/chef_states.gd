class_name ChefStates
extends StateMachine

enum State { WALKING, FALLING, IDLE }

@export var chef: Chef
@export var audio_set: ChefAudioSet


func _ready() -> void:
	state_functions = {
		State.WALKING: "walking",
		State.IDLE: "idle",
		State.FALLING: "falling",
	}


func idle(command: Command, _data: Variant) -> void:
	match command:
		Command.ENTER:
			chef.animation.play("idle")
		Command.CHECK:
			if chef.is_on_floor():
				if chef.movement_manager.input_axis != 0:
					change_state(State.WALKING)
			else:
				change_state(State.FALLING)


func walking(command: Command, _data: Variant) -> void:
	match command:
		Command.ENTER:
			chef.animation.play("walking")
			audio_set.is_walking = true
		Command.CHECK:
			if chef.is_on_floor():
				if chef.movement_manager.input_axis == 0:
					change_state(State.IDLE)
			else:
				change_state(State.FALLING)
		Command.EXIT:
			audio_set.is_walking = false


func falling(command: Command, _data: Variant) -> void:
	match command:
		Command.ENTER:
			chef.animation.play("falling")
		Command.CHECK:
			if chef.is_on_floor():
				chef.animation.play("hit_floor")
				if not audio_set.walk_sounds[3].playing:
					audio_set.walk_sounds[3].play()
				await chef.animation.animation_finished
				if chef.movement_manager.input_axis == 0:
					change_state(State.IDLE)
				else:
					change_state(State.WALKING)
