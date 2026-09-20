extends Interactable

signal opened

@onready var door: TileMapLayer = $TileMapLayer2

func _ready() -> void:
	door.visible = false

func interact(player: CharacterBody2D):
	door.visible = true
	opened.emit()
	super.interact(player)
