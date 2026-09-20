extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var arrow_down = $ArrowDown
@onready var change_scene = $ChangeScene
@onready var key_area = $Key

var door_opened := false

func _ready():
	AudioManager.play_bgm(THEME_SONG)
	change_scene.hide()
	arrow_down.hide()

	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom

func _process(_delta: float) -> void:
	if door_opened:
		return

	if Input.is_action_just_pressed("action"):
		var in_area = key_area.overlaps_body(cat) or key_area.overlaps_area(cat.get_node("InteractionArea"))
		if in_area:
			door_opened = true
			Dialog.show_dialogue("The door won't open. There might be a key somewhere in the garden.")
			cat.show_chat_emoji("lock", 2)
			arrow_down.show()
			change_scene.show()
