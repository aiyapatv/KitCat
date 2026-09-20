extends CharacterBody2D

var kick_velocity := Vector2.ZERO

@export var friction := 500.0

func apply_kick(force: Vector2):
	kick_velocity = force

func _physics_process(delta):
	if kick_velocity.length() > 0:
		velocity = kick_velocity
		move_and_slide()

		kick_velocity = kick_velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)
