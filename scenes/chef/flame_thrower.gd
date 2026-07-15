extends Node2D

@onready var ray: RayCast2D = %RayCast2D
@export var particles: GPUParticles2D
@export var body: Chef
@export var knockback: float = 50


func _physics_process(_delta: float) -> void:
	particles.emitting = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if particles.emitting:
		body.movement_manager.knockback = (Vector2(knockback, 0).rotated(rotation) * -1)
		var collision_point: Vector2 = ray.get_collision_point()
		if collision_point != Vector2.ZERO:
			var target: Igredient = ray.get_collider() as Igredient
			if not target is Igredient:
				return
			target.paint(collision_point)
	else:
		body.movement_manager.knockback = Vector2.ZERO
	follow_mouse()


func follow_mouse() -> void:
	look_at(get_global_mouse_position())
