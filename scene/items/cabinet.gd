extends Interactable

@onready var door: TileMapLayer = $TileMapLayer2

func _ready() -> void:
	door.visible = false

func interact():
	door.visible = !door.visible;
	print(interaction_text)
