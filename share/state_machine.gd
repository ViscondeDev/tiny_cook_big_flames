@icon("uid://bsoyx5pe5itu2")
class_name StateMachine
extends Node

@export var debug_logs: bool = false

enum Command { ENTER, EXIT, EVENT, CHECK }

var current_state: int
var state_functions: Dictionary = { }


func _physics_process(_delta: float) -> void:
	execute_state(current_state, Command.CHECK)


func execute_state(state: int, command: Command, data: Variant = null) -> void:
	call(state_functions[state], command, data)


func recieve_event(data: Variant) -> void:
	call(state_functions[current_state], Command.EVENT, data)


func change_state(new_state: int, data: Variant = null) -> void:
	var previous_state: int = current_state
	execute_state(current_state, Command.EXIT, data)
	current_state = new_state
	execute_state(current_state, Command.ENTER, data)

	if debug_logs:
		print(
			"Node: ",
			self.name,
			" - Previous state:",
			previous_state,
			" -> ",
			current_state,
		)
