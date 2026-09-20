extends Control

signal completed
signal failed

@export_category("Game Settings")
@export var rounds: int = 3
@export var characters_per_round: int = 5
@export var time_limit: float = 3.0
@export var cooldown_duration: float = 1.5

@export_category("Character")
@export var character_scene: PackedScene
@export var character_spacing: float = 20.0

@export_category("Input")
@export var available_characters: Array[String] = [
	"ArrowUp",
	"ArrowLeft",
	"ArrowDown",
	"ArrowRight"
	]

@export_category("Bar Colors")
@export var color_normal: Color = Color("fec66cff")
@export var color_cooldown: Color = Color("fc9343ff")
@export var color_complete: Color = Color("89b88aff")
@export var color_failed: Color = Color("af7551ff")

@onready var sequence: Node2D = $Sequence
@onready var timer_bar: ProgressBar = $TimerBar
@onready var timer: Timer = $Timer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var current_round := 0
var current_sequence: Array[String] = []
var current_index := 0

var character_slots: Array[ReactionCharacter] = []

var game_active := false
var is_in_cooldown := false

var fill_stylebox: StyleBoxFlat
var bg_stylebox: StyleBoxFlat

func _ready():
	timer.timeout.connect(_on_timer_timeout)

	bg_stylebox = StyleBoxFlat.new()
	bg_stylebox.bg_color = Color(0, 0, 0, 0)
	bg_stylebox.shadow_size = 0
	bg_stylebox.shadow_color = Color(0, 0, 0, 0)
	bg_stylebox.set_corner_radius_all(8)

	fill_stylebox = StyleBoxFlat.new()
	fill_stylebox.bg_color = color_normal
	fill_stylebox.shadow_size = 0
	fill_stylebox.shadow_color = Color(0, 0, 0, 0)
	fill_stylebox.set_corner_radius_all(8)

	if is_instance_valid(timer_bar):
		timer_bar.show_percentage = false
		timer_bar.add_theme_stylebox_override("background", bg_stylebox)
		timer_bar.add_theme_stylebox_override("fill", fill_stylebox)
		timer_bar.value = 0.0

func _process(_delta):
	if game_active and not is_in_cooldown:
		if time_limit > 0:
			timer_bar.value = (timer.time_left / time_limit) * 100.0

func start_game():
	audio.play()
	current_round = 0
	start_round()

func start_round():
	current_round += 1

	if current_round > rounds:
		finish_game()
		return

	generate_sequence()

	current_index = 0
	game_active = false

	timer.stop()

	create_character_slots()
	update_display()

	await cooldown()

func cooldown():
	is_in_cooldown = true
	fill_stylebox.bg_color = color_cooldown
	timer_bar.value = 0.0

	var tween := create_tween()
	tween.tween_property(timer_bar, "value", 100.0, cooldown_duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	is_in_cooldown = false
	fill_stylebox.bg_color = color_normal

	game_active = true

	timer.wait_time = time_limit
	timer.start()

	update_display()

func generate_sequence():
	current_sequence.clear()

	for i in characters_per_round:
		current_sequence.append(
			available_characters.pick_random()
		)

func create_character_slots():
	for character in character_slots:
		if is_instance_valid(character):
			character.queue_free()

	character_slots.clear()

	for i in characters_per_round:
		var character := character_scene.instantiate() as ReactionCharacter

		sequence.add_child(character)

		character.position = Vector2(
			i * character_spacing,
			0
		)

		character_slots.append(character)

func _input(event):
	if not game_active or is_in_cooldown:
		return

	if not event.is_pressed():
		return

	if event is InputEventKey and event.echo:
		return

	var character := get_character_from_event(event)

	if character == "":
		return

	check_input(character)

func get_character_from_event(event: InputEvent) -> String:
	if event is InputEventKey:
		match event.keycode:
			KEY_W:
				return "ArrowUp"

			KEY_A:
				return "ArrowLeft"

			KEY_S:
				return "ArrowDown"

			KEY_D:
				return "ArrowRight"

	return ""

func check_input(character: String):
	if current_index >= current_sequence.size():
		return

	var expected_character := current_sequence[current_index]

	if character == expected_character:
		character_slots[current_index].set_complete(
			expected_character
		)

		current_index += 1

		update_display()

		if current_index >= current_sequence.size():
			complete_round()

	else:
		game_over()

func complete_round():
	game_active = false
	timer.stop()

	fill_stylebox.bg_color = color_complete
	timer_bar.value = 100.0

	await get_tree().create_timer(0.5).timeout

	start_round()

func _on_timer_timeout():
	game_over()

func game_over():
	game_active = false
	is_in_cooldown = false
	timer.stop()

	fill_stylebox.bg_color = color_failed
	timer_bar.value = 100.0
	audio.stop()

	await get_tree().create_timer(1.5).timeout

	failed.emit()

func finish_game():
	game_active = false
	is_in_cooldown = false
	timer.stop()

	fill_stylebox.bg_color = color_complete
	timer_bar.value = 100.0
	audio.stop()

	await get_tree().create_timer(1.5).timeout

	completed.emit()

func update_display():
	for i in character_slots.size():
		if i >= current_sequence.size():
			continue

		var character_key := current_sequence[i]

		if i < current_index:
			character_slots[i].set_complete(character_key)
		else:
			character_slots[i].setup(character_key)
