extends CanvasLayer

var color_rect: ColorRect

func _ready() -> void:
	layer = 128
	
	color_rect = ColorRect.new()
	color_rect.color = Color.BLACK
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.visible = false
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_rect)

func change_scene_to_file(target_path: String, black_duration: float = 0.5) -> void:
	# Show black screen instantly
	color_rect.visible = true
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if black_duration > 0:
		await get_tree().create_timer(black_duration).timeout
	else:
		await get_tree().process_frame
		
	var err := get_tree().change_scene_to_file(target_path)
	if err != OK:
		push_error("Failed to load scene: %s" % target_path)
	
	await get_tree().process_frame
	if black_duration > 0:
		await get_tree().create_timer(black_duration).timeout
		
	color_rect.visible = false
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene_to_packed(target_packed: PackedScene, black_duration: float = 0.5) -> void:
	color_rect.visible = true
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if black_duration > 0:
		await get_tree().create_timer(black_duration).timeout
	else:
		await get_tree().process_frame
		
	var err := get_tree().change_scene_to_packed(target_packed)
	if err != OK:
		push_error("Failed to load packed scene")
		
	await get_tree().process_frame
	if black_duration > 0:
		await get_tree().create_timer(black_duration).timeout
		
	color_rect.visible = false
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
