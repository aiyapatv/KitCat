class_name Interactable
extends Area2D

@export var interaction_text := "Interact"
@export var prompt_prefix := "[J] "
@export var is_kickable := false
@export var kick_force := 150.0

@export_file("*.tscn") var target_scene: String = ""

func interact(player: CharacterBody2D):
	if is_kickable:
		kick(player)
		return

	if target_scene != "":
		SceneManager.change_scene_to_file(target_scene)

func kick(player: CharacterBody2D):
	var direction := global_position - player.global_position
	direction = direction.normalized()

	var object := get_parent()

	if object.has_method("apply_kick"):
		object.apply_kick(direction * kick_force)
