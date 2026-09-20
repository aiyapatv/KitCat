extends Node2D

const THEME_SONG = preload("res://resource/Theme Song.mp3")

@onready var cat = $TopDownCat
@onready var camera_bounds = $CameraBounds
@onready var cabinet_sprite = $CabinetSprite
@onready var cabinet = $Cabinet
@onready var letter = $Letter
@onready var letter2 = $Letter2
@onready var letter_text: Label = $Letter2/Label
@onready var letter3 = $Letter3
@onready var grandma = $Grandma

var table := false
var letter_is_down := false
var end := false
var letter_is_open := false
var count := 0
var text_arr := [
	"My dear daughter,

I don’t know why, but I felt like writing you a letter today. Perhaps… somewhere in my heart, I know that my time is coming soon.

The little one is doing well, as always. He ate until his belly was round, then curled up and fell fast asleep.

I love him so much.

And I’m sorry that I have to leave before he does.

Though, to him, I suppose I’m just another human. Haha…",
"Still, I have one last favor to ask of you.
Please take care of my little cat for me.

He still loves that little ball of his, and I swear he could play with that wind-up mouse forever. When he's tired, you'll find him curled up on the green cushion, as always.

And when you go outside to water the plants, don't forget to let him follow you out. He loves lying in the sunlight, even if he pretends he's too busy to enjoy it.

Scratch his chin. Rub his belly.  He may pretend he doesn’t care, but just wait. He’ll come looking for you soon enough.",
"If I could, I would thank that little boy one more time.
For all these years, he kept this old woman from feeling quite so lonely.

So, my dear daughter…
Please take care of my precious little companion.
And when he comes curling up beside you, don’t push him away.
Let him stay.
Maybe then, for a little while longer, you won’t feel quite so alone either.
Love, Mom "
]
func _ready():
	AudioManager.play_bgm(THEME_SONG)
	cabinet_sprite.hide()
	letter.hide()
	letter2.hide()
	var camera = cat.get_node("Camera2D")

	camera.limit_left = camera_bounds.left
	camera.limit_top = camera_bounds.top
	camera.limit_right = camera_bounds.right
	camera.limit_bottom = camera_bounds.bottom

func _process(delta: float) -> void:
	if cabinet.get_overlapping_areas() and not table:
		Dialog.show_dialogue("A letter, left waiting on the table... ")
		table = true
	elif cabinet.get_overlapping_areas() and table and not letter_is_open and not letter_is_down and Input.is_action_just_pressed("action"):
		cabinet_sprite.show()
		letter.show()
		letter_is_down = true
	elif letter3.get_overlapping_areas() and not letter_is_open and letter_is_down and Input.is_action_just_pressed("action"):
		letter2.show()
		letter_is_open = true
		count += 1
	elif count < 3 and letter_is_open and letter_is_down and Input.is_action_just_pressed("action"):
		letter_text.text = text_arr[count]
		count += 1
	elif count == 3 and Input.is_action_just_pressed("action"):
		count += 1
	elif count == 4:
		letter2.hide()
		end = true
	if end and grandma.get_overlapping_areas():
		SceneManager.change_scene_to_file("res://scene/levels/End.tscn")
