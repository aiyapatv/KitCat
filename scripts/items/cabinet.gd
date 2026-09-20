extends Interactable

@onready var door: TileMapLayer = $TileMapLayer2

func _ready() -> void:
	door.visible = false

func interact(player: CharacterBody2D):
	door.visible = !door.visible
	super.interact(player)
