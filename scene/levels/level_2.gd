extends Node2D

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var cushion = $Cushion
@onready var outside_arrow = $OutsideArrow
@onready var up_arrow = $UpArrow

func _ready():
	outside_arrow.visible = false
	up_arrow.visible = false
	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom

func _process(delta: float) -> void:
	var items = cushion.get_overlapping_areas()
	if items.size() == 6:
		outside_arrow.visible = false
		#SceneManager.change_scene_to_file("res://scene/levels/Level3Minigame.tscn")
