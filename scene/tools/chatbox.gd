class_name Chatbox
extends Node2D

@export var default_emoji: String = ""
@export var auto_hide_duration: float = 0.0

@onready var _container: Node = $ChatBox

func _ready() -> void:
	if default_emoji != "":
		show_emoji(default_emoji, auto_hide_duration)
	else:
		hide_chatbox()

func hide_chatbox() -> void:
	hide()
	for child in _container.get_children():
		child.hide()

func show_emoji(emoji_name: String, duration: float = 0.0) -> void:
	hide_chatbox()
	var target: Node = null
	for child in _container.get_children():
		if child.name.to_lower() == emoji_name.to_lower():
			target = child
			break

	if target:
		target.show()
		show()
		var delay: float = duration if duration > 0.0 else auto_hide_duration
		if delay > 0.0:
			await get_tree().create_timer(delay).timeout
			if target.visible:
				hide_chatbox()
