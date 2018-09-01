extends RigidBody2D

const ATTRACTOR_MIN_MOUSE_DIST = 75
const ATTRACTOR_MIN_MOUSE_DIST_SQUARED = ATTRACTOR_MIN_MOUSE_DIST * ATTRACTOR_MIN_MOUSE_DIST
const FORCE = 50

onready var sprite = get_node("sprite")
onready var rays = get_node("rays")
onready var camera = get_node("camera")

onready var nearby_attractors = []

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)

func _process(delta):
	pass

func _physics_process(delta):
	var multiplier = 0
	if Input.is_action_pressed("elfin_pull"):
		multiplier = 1
	if Input.is_action_pressed("elfin_push"):
		multiplier = -1

	if multiplier != 0 and len(nearby_attractors) > 0:
		# A force is being applied. Calculate the force.
		multiplier = multiplier / float(len(nearby_attractors))

		for attractor in nearby_attractors:
			var force = (attractor.global_position - global_position).normalized()
			force *= FORCE
			force *= multiplier
			apply_impulse(Vector2(0, 0), force)

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