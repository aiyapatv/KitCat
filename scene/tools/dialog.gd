extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	self.hide()

func show_dialogue(text: String):
	label.text = text
	self.show()
	await get_tree().create_timer(3.0).timeout
	self.hide()

func hide_dialogue():
	self.hide()
