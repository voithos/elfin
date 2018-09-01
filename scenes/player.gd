extends RigidBody2D

const ATTRACTOR_MIN_MOUSE_DIST = 75
const ATTRACTOR_MIN_MOUSE_DIST_SQUARED = ATTRACTOR_MIN_MOUSE_DIST * ATTRACTOR_MIN_MOUSE_DIST
const FORCE = 65

onready var sprite = get_node("sprite")
onready var rays = get_node("rays")
onready var camera = get_node("camera")

const STATE_IDLE = "IDLE"
const STATE_PUSHPULL = "PUSHPULL"

onready var nearby_attractors = []
onready var state = STATE_IDLE

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
		state = STATE_PUSHPULL
		multiplier = multiplier / float(len(nearby_attractors))

		for attractor in nearby_attractors:
			var force = (attractor.global_position - global_position).normalized()
			force *= FORCE
			force *= multiplier
			apply_impulse(Vector2(0, 0), force)
			
			_flip_sprite_based_on(attractor.global_position)
	else:
		# Idle.
		var last_state = state
		state = STATE_IDLE
		if last_state == STATE_PUSHPULL:
			# We exited from pushpull.
			_update_based_on_mouse()

func _handle_mouse_motion(event):
	if state == STATE_PUSHPULL:
		return
	_update_based_on_mouse()

func _update_based_on_mouse():
	_flip_sprite_based_on(get_global_mouse_position())
	_collect_attractors()

func _flip_sprite_based_on(target):
	# Flip sprite to the direction target is facing.
	sprite.flip_h = global_position.x > target.x

func _collect_attractors():
	# Determine target attractors.
	var attractors = get_tree().get_nodes_in_group("attractors")
	var nearby = []
	for attractor in attractors:
		if get_global_mouse_position().distance_squared_to(attractor.global_position) < ATTRACTOR_MIN_MOUSE_DIST_SQUARED:
			nearby.append(attractor)

	nearby_attractors = nearby