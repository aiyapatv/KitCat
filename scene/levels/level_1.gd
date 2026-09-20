extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var outside_arrow = $OutsideArrow
@onready var change_scene = $ChangeScene
@onready var cabinet = $Cabinet
@onready var rhythm_canvas = $Rhythm
@onready var rhythm_game = $Rhythm/Rhythm
@onready var cat_food = $CatFood
@onready var cat_food2 = $CatFood2

var rhythm_completed := false

func _ready():
	Dialog.show_dialogue("The cat looks hungry. There must be some food around here.")
	cat.show_chat_emoji("sad", 2)
	AudioManager.play_bgm(THEME_SONG)
	change_scene.hide()
	outside_arrow.hide()
	rhythm_canvas.hide()
	cat_food.hide()
	cat_food2.hide()

	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom

	cabinet.opened.connect(_on_cabinet_opened)
	rhythm_game.completed.connect(_on_rhythm_completed)
	rhythm_game.failed.connect(_on_rhythm_failed)

func _on_cabinet_opened():
	if rhythm_completed:
		return
	cat_food.show()
	cat.velocity = Vector2.ZERO
	cat.set_physics_process(false)
	AudioManager.pause_bgm()
	rhythm_canvas.show()
	rhythm_game.start_game()

func _on_rhythm_failed():
	rhythm_canvas.hide()
	AudioManager.resume_bgm()
	cat.set_physics_process(true)

func _on_rhythm_completed():
	rhythm_completed = true
	rhythm_canvas.hide()
	cat.set_physics_process(true)
	cat_food.hide()
	cat_food2.show()	
	cat.show_chat_emoji("heart", 2)
	AudioManager.resume_bgm()
	change_scene.show()
	outside_arrow.show()
