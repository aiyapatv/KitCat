extends Node2D

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds

func _ready():
	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom
