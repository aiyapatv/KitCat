extends StaticBody2D

## Obstacle width and height in pixels
@export var obstacle_width: float = 12.0
@export var obstacle_height: float = 18.0

## Visual color
@export var obstacle_color: Color = Color(0.85, 0.3, 0.2)

## When true, the obstacle hangs DOWN from its node position (ceiling obstacle).
## Place the node at Y=0 and set obstacle_height to how far it should hang.
## When false (default), the obstacle sticks UP from its node position (ground obstacle).
## Place the node at Y=115 (ground surface) for ground obstacles.
@export var is_ceiling: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect = $Visual

func _ready() -> void:
	var rect := RectangleShape2D.new()
	rect.size = Vector2(obstacle_width, obstacle_height)
	collision_shape.shape = rect
	visual.size = Vector2(obstacle_width, obstacle_height)

	if is_ceiling:
		# Top of obstacle is at node origin, hangs downward
		collision_shape.position = Vector2(0.0, obstacle_height / 2.0)
		visual.position = Vector2(-obstacle_width / 2.0, 0.0)
	else:
		# Bottom of obstacle is at node origin, sticks upward
		collision_shape.position = Vector2(0.0, -obstacle_height / 2.0)
		visual.position = Vector2(-obstacle_width / 2.0, -obstacle_height)

	visual.color = obstacle_color
