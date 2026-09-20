extends Node2D

@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
const THEME_SONG = preload("res://resource/Theme Song.mp3")

func _ready() -> void:
	animate.play()
	AudioManager.play_bgm(THEME_SONG)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		SceneManager.change_scene_to_file("res://scene/levels/Level1.tscn")
