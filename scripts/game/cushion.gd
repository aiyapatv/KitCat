extends Area2D

func _process(delta: float) -> void:
	if self.get_overlapping_areas().size() == 6:
		SceneManager.change_scene_to_file("res://scene/levels/Level3Minigame.tscn")
