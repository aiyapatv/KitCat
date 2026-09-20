extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	self.hide()

func show_dialogue(text: String):
	label.text = text
	self.show()

func hide_dialogue():
	self.hide()
