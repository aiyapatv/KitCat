extends Control

@export_category("Game Settings")
@export var rounds: int = 3
@export var characters_per_round: int = 5
@export var time_limit: float = 3.0

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

@onready var sequence: Node2D = $Sequence
@onready var progress_label: Label = $ProgressLabel
@onready var timer_label: Label = $TimerLabel
@onready var countdown_label: Label = $CountdownLabel
@onready var timer: Timer = $Timer

var current_round := 0
var current_sequence: Array[String] = []
var current_index := 0

var character_slots: Array[ReactionCharacter] = []

var game_active := false

func _ready():
	timer.timeout.connect(_on_timer_timeout)

	countdown_label.hide()

	start_game()

func _process(_delta):
	if game_active:
		timer_label.text = "%d" % ceil(timer.time_left)
	else:
		timer_label.text = ""

func start_game():
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

	await countdown()

func countdown():
	countdown_label.show()

	for number in [3, 2, 1]:
		countdown_label.text = str(number)
		await get_tree().create_timer(1.0).timeout

	countdown_label.text = "GO!"

	await get_tree().create_timer(0.4).timeout

	countdown_label.hide()

	# Start the round
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
	if not game_active:
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

	await get_tree().create_timer(0.5).timeout

	start_round()

func _on_timer_timeout():
	game_over()

func game_over():
	game_active = false
	timer.stop()

	countdown_label.show()
	countdown_label.text = "FAILED!"

	timer_label.text = ""

	await get_tree().create_timer(1.5).timeout

	countdown_label.hide()

func finish_game():
	game_active = false
	timer.stop()

	countdown_label.show()
	countdown_label.text = "COMPLETE!"

	timer_label.text = ""

func update_display():
	for i in character_slots.size():
		if i >= current_sequence.size():
			continue

		var character_key := current_sequence[i]

		if i < current_index:
			character_slots[i].set_complete(character_key)
		else:
			character_slots[i].setup(character_key)

	progress_label.text = "Round %d / %d" % [
		current_round,
		rounds
	]
