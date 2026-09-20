extends CharacterBody2D

@export var speed := 60.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var chatbox: Chatbox = $Chatbox

func _ready():
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("idle")

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
	if animated_sprite.animation == "hit":
		return
	
	if velocity == Vector2.ZERO:
		animated_sprite.stop()
		return

	animated_sprite.play("idle")

	if velocity.x != 0:
		animated_sprite.flip_h = velocity.x < 0

func handle_interaction():
	if not Input.is_action_just_pressed("action"):
		return
	animated_sprite.flip_h = true
	animated_sprite.play("hit")

	var interactables = interaction_area.get_overlapping_areas()

	for area in interactables:
		if area.has_method("interact"):
			area.interact(self)
			break

func _on_animation_finished():
	if animated_sprite.animation == "hit":
		animated_sprite.flip_h = false
		animated_sprite.play("idle")

func show_chat_emoji(emoji, duration: float = 0.0) -> void:
	if chatbox:
		chatbox.show_emoji(emoji, duration)

func hide_chat_emoji() -> void:
	if chatbox:
		chatbox.hide_chatbox()
