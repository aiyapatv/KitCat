extends CharacterBody2D

@export var speed := 60.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea

func _physics_process(_delta):
	handle_movement()
	handle_animation()
	handle_interaction()
	move_and_slide()

func handle_movement():
	var direction := Vector2.ZERO

	if Input.is_action_pressed("left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("down"):
		direction = Vector2.DOWN

	velocity = direction * speed

func handle_animation():
	if velocity == Vector2.ZERO:
		animated_sprite.stop()
		return
	animated_sprite.play()
	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0
		
func handle_interaction():
	if Input.is_action_just_pressed("action"):
		var interactables = interaction_area.get_overlapping_areas()
		
		if interactables.size() > 0 and interactables[0].has_method("interact"):
			interactables[0].interact()
