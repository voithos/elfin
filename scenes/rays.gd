extends Node2D

const SPRITE_SCALE = 3

onready var player = get_parent()

func _ready():
	pass

func _process(delta):
	update()

func _draw():
	if len(player.nearby_attractors) > 0:
		for attractor in player.nearby_attractors:
			draw_line(Vector2(0, 0), player.to_local(attractor.global_position) / SPRITE_SCALE, Color(255, 0, 0), 1)