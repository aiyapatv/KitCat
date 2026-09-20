extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var key = $Key
@onready var key2 = $Key2
@onready var change_scene = $ChangeScene
@onready var up_arrow = $UpArrow

var door_opened := false

func _ready():
	AudioManager.play_bgm(THEME_SONG)
	var camera = cat.get_node("Camera2D")
	change_scene.hide()
	up_arrow.hide()

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		var in_area = key2.overlaps_body(cat) or key2.overlaps_area(cat.get_node("InteractionArea"))
		if in_area:
			key.hide()
			change_scene.show()
			up_arrow.show()
