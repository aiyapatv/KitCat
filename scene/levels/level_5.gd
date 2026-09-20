extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var left_arrow = $ArrowLeft
@onready var change_scene = $ChangeScene
@onready var rhythm_canvas = $Rhythm
@onready var rhythm_game = $Rhythm/Rhythm
@onready var action_area = $ActionArea

@onready var sunflowers = [
	$Sunflower1,
	$Sunflower2,
	$Sunflower3,
	$Sunflower4
]

var rhythm_completed := false
var rhythm_started := false
var sunflowers_hidden_count := 0
var rhythm_speed = 6

func _ready():
	AudioManager.play_bgm(THEME_SONG)
	change_scene.hide()
	left_arrow.hide()
	rhythm_canvas.hide()

	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom

	rhythm_game.completed.connect(_on_rhythm_completed)
	rhythm_game.failed.connect(_on_rhythm_failed)

func _process(_delta: float) -> void:
	if rhythm_completed or rhythm_started:
		return

	if Input.is_action_just_pressed("action"):
		var in_area = action_area.overlaps_body(cat) or action_area.overlaps_area(cat.get_node("InteractionArea"))
		if in_area:
			rhythm_started = true
			cat.velocity = Vector2.ZERO
			cat.set_physics_process(false)
			rhythm_game.time_limit = rhythm_speed
			AudioManager.pause_bgm()
			rhythm_canvas.show()
			rhythm_game.start_game()

func _on_rhythm_failed():
	rhythm_started = false
	rhythm_canvas.hide()
	AudioManager.resume_bgm()
	cat.set_physics_process(true)

func _on_rhythm_completed():
	rhythm_started = false
	rhythm_canvas.hide()
	AudioManager.resume_bgm()
	cat.set_physics_process(true)
	rhythm_speed -= 1

	if sunflowers_hidden_count < sunflowers.size():
		sunflowers[sunflowers_hidden_count].hide()
		sunflowers_hidden_count += 1

	if sunflowers_hidden_count >= sunflowers.size():
		rhythm_completed = true
		Dialog.show_dialogue("Something's glowing on the green cushion...")
		change_scene.show()
		left_arrow.show()
