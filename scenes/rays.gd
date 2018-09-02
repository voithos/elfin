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

	var color = Color(1, 1, 1, 1)
	if player.state == player.STATE_PUSHPULL:
		if player.pushpull_dir == 'pull':
			color = Color(201/255.0, 36/255.0, 100/255.0, 1)
		else:
			color = Color(17/255.0, 173/255.0, 193/255.0, 1)
	
	draw_line(from, to, color, 2)