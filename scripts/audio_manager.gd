extends Node

var bgm_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGMPlayer"
	add_child(bgm_player)

func play_bgm(stream: AudioStream) -> void:
	if stream == null:
		stop_bgm()
		return
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.stream_paused = false
	bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()
	bgm_player.stream = null

func pause_bgm() -> void:
	bgm_player.stream_paused = true

func resume_bgm() -> void:
	bgm_player.stream_paused = false
