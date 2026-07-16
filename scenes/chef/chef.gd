class_name Chef
extends CharacterBody2D

@onready var sprite: Sprite2D = %Sprite2D
@onready var input_manager: InputManager = %InputManager
@onready var movement_manager: MovementComponent = %MovementComponent
@onready var flame_thrower: FlameThrower = %FlameThrower
@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var state_machine: ChefStates = %StateMachine


func _ready() -> void:
	state_machine.change_state(state_machine.State.IDLE)


func _physics_process(_delta: float) -> void:
	if not input_manager.enabled:
		return
	input_manager.get_actions()
	var direction: float = input_manager.get_directional_inputs()
	movement_manager.input_axis = direction

	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false


func jump() -> void:
	if is_on_floor():
		movement_manager.jump()


func apply_knockback(force: Vector2) -> void:
	movement_manager.knockback = force
