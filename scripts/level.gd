extends Node2D

onready var music = get_node("/root/music")

const NEXT_LEVEL_TIMEOUT = 1
const RESET_TIMEOUT = 1

export (String, FILE, "*.tscn") var next_level

func _ready():
	assert(next_level != null)
	add_to_group("level")
	music.play_level()

func begin_next_level_transition():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_load_next_level")
	timer.wait_time = NEXT_LEVEL_TIMEOUT
	timer.one_shot = true
	timer.start()

func begin_reset_transition():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_reset_level")
	timer.wait_time = RESET_TIMEOUT
	timer.one_shot = true
	timer.start()

func _load_next_level():
	get_tree().change_scene(next_level)

func _reset_level():
	get_tree().reload_current_scene()