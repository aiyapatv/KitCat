extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var animate = $AnimatedSprite2D
@onready var color = $ColorRect

func _ready() -> void:
	animate.play()
	AudioManager.play_bgm(THEME_SONG)

func _process(delta: float) -> void:
	color.hide()
	await get_tree().create_timer(5.0).timeout
	color.show()
