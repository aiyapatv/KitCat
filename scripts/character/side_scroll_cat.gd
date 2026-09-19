extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 90.0
@export var jump_velocity: float = -155.0
@export var gravity: float = 400.0

var jump_count: int = 0
const MAX_JUMPS := 2


func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("default")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_input()

	velocity.x = speed
	move_and_slide()

	if is_on_floor():
		jump_count = 0

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_input() -> void:
	if Input.is_action_just_pressed("action") and jump_count < MAX_JUMPS:
		velocity.y = jump_velocity
		jump_count += 1
		animated_sprite.stop()
		animated_sprite.play("jump")

func _on_animation_finished() -> void:
	if animated_sprite.animation == "jump":
		animated_sprite.play("default")
