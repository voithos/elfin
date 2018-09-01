extends Node2D

onready var player = get_parent()

func _ready():
	pass

func _process(delta):
	update()

func _draw():
	if len(player.nearby_attractors) > 0:
		for attractor in player.nearby_attractors:
			_draw_attractor_ray(attractor)

func _draw_attractor_ray(attractor):
	var from = Vector2(0, 0)
	var to = player.to_local(attractor.global_position)
	
	draw_line(from, to, Color(1, 1, 1, 1), 2)