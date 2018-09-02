extends Node2D

onready var music = get_node("/root/music")

const NEXT_LEVEL_TIMEOUT = 1

export (String, FILE, "*.tscn") var next_level

func _ready():
	assert(next_level != null)
	add_to_group("level")
	music.play_level()

func begin_next_level_transition():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_begin_next_level_transition")
	timer.wait_time = NEXT_LEVEL_TIMEOUT
	timer.one_shot = true
	timer.start()

# TODO: Get rid of this indirection after the goal animation is changed to a sprite.
func _begin_next_level_transition():
	var transition = get_tree().get_nodes_in_group("transition")[0]
	transition.connect("fade_complete", self, "_load_next_level")
	transition.begin_fade()

func begin_reset_transition():
	var transition = get_tree().get_nodes_in_group("transition")[0]
	transition.connect("fade_complete", self, "_reset_level")
	transition.begin_fade()

func _load_next_level():
	get_tree().change_scene(next_level)

func _reset_level():
	get_tree().reload_current_scene()