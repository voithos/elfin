extends Node2D

onready var music = get_node("/root/music")

const FIRST_LEVEL = "res://scenes/levels/level_tut_motion.tscn"

func _ready():
	music.play_level()

func _input(event):
	if Input.is_action_pressed("elfin_pull") or Input.is_action_pressed("elfin_push"):
		# Start the game.
		var transition = get_tree().get_nodes_in_group("transition")[0]
		transition.connect("fade_complete", self, "_load_next_level")
		transition.begin_fade()

func _load_next_level():
	get_tree().change_scene(FIRST_LEVEL)