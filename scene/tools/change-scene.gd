extends Area2D

@export_file("*.tscn") var target_scene: String = ""

func _process(delta: float) -> void:
	if self.get_overlapping_areas():
		SceneManager.change_scene_to_file(target_scene)
