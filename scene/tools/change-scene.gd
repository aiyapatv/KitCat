extends Area2D

@export_file("*.tscn") var target_scene: String = ""

func _process(_delta: float) -> void:
	monitoring = is_visible_in_tree()
	if not monitoring:
		return
	if self.get_overlapping_areas():
		SceneManager.change_scene_to_file(target_scene)
