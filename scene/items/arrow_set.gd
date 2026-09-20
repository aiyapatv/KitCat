class_name ReactionCharacter
extends Node2D

func setup(character: String):
	for child in get_children():
		child.hide()

	var character_node := get_node(character)
	character_node.show()

	character_node.get_node("Complete").hide()
	character_node.get_node("Incomplete").show()


func set_complete(character: String):
	for child in get_children():
		child.hide()

	var character_node := get_node(character)
	character_node.show()

	character_node.get_node("Incomplete").hide()
	character_node.get_node("Complete").show()
