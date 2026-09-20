extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		SceneManager.change_scene_to_file("res://scene/levels/Level1.tscn")
