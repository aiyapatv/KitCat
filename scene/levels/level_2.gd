extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var cushion = $Cushion
@onready var change_scene = $ChangeScene
@onready var up_arrow = $UpArrow
@onready var rhythm_canvas = $Rhythm
@onready var rhythm_game = $Rhythm/Rhythm

var rhythm_completed := false
var rhythm_started := false

func _ready():
	AudioManager.play_bgm(THEME_SONG)
	cat.show_chat_emoji("sad", 2)
	Dialog.show_dialogue("Toys scattered all over the room... Let's put them on the green cushion.")
	up_arrow.hide()
	change_scene.hide()
	rhythm_canvas.hide()

	rhythm_game.completed.connect(_on_rhythm_completed)
	rhythm_game.failed.connect(_on_rhythm_failed)

	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom

func _process(delta: float) -> void:
	var items = cushion.get_overlapping_areas()
	if items.size() == 6 and Input.is_action_just_pressed("action"):
		if rhythm_completed or rhythm_started:
			return
		rhythm_started = true
		cat.velocity = Vector2.ZERO
		cat.set_physics_process(false)
		rhythm_game.time_limit = 8
		AudioManager.pause_bgm()
		rhythm_canvas.show()
		rhythm_game.start_game()

func _on_rhythm_failed():
	rhythm_started = false
	rhythm_canvas.hide()
	AudioManager.resume_bgm()
	cat.set_physics_process(true)

func _on_rhythm_completed():
	rhythm_completed = true
	rhythm_canvas.hide()
	AudioManager.resume_bgm()
	Dialog.show_dialogue("The cat keeps looking around... Is he waiting for someone?")
	cat.set_physics_process(true)
	cat.show_chat_emoji("question", 2)
	change_scene.show()
	up_arrow.show()
