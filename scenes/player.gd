extends RigidBody2D

const ATTRACTOR_MIN_MOUSE_DIST = 75
const ATTRACTOR_MIN_MOUSE_DIST_SQUARED = ATTRACTOR_MIN_MOUSE_DIST * ATTRACTOR_MIN_MOUSE_DIST

onready var sprite = get_node("sprite")
onready var rays = get_node("rays")

onready var nearby_attractors = []

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)

func _process(delta):
	pass

func _handle_mouse_motion(event):
	# Flip sprite to the direction mouse is facing.
	sprite.flip_h = global_position.x > event.position.x
	
	# Determine target attractors.
	var attractors = get_tree().get_nodes_in_group("attractors")
	var nearby = []
	for attractor in attractors:
		if event.position.distance_squared_to(attractor.global_position) < ATTRACTOR_MIN_MOUSE_DIST_SQUARED:
			nearby.append(attractor)

	nearby_attractors = nearby