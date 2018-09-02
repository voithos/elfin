extends RigidBody2D

const ATTRACTOR_MIN_MOUSE_DIST = 75
const ATTRACTOR_MIN_MOUSE_DIST_SQUARED = ATTRACTOR_MIN_MOUSE_DIST * ATTRACTOR_MIN_MOUSE_DIST
const FORCE = 65

onready var sfx = get_node("/root/sfx")

onready var sprite = get_node("sprite")
onready var rays = get_node("rays")
onready var camera = get_node("camera")
onready var animation = get_node("animation")

const STATE_IDLE = "IDLE"
const STATE_PUSHPULL = "PUSHPULL"
const STATE_VICTORY = "VICTORY"
const STATE_DYING = "DYING"
const STATE_MATERIALIZING = "MATERIALIZING"

onready var nearby_attractors = []
onready var state = STATE_MATERIALIZING
var pushpull_dir = null

func _ready():
	sprite.modulate.a = 0
	call_deferred("_register_with_transition")

func _register_with_transition():
	var transition = get_tree().get_nodes_in_group("transition")[0]
	transition.connect("unfade_complete", self, "_on_unfade_complete")

func _on_unfade_complete():
	animation.play("birth_implosion")
	sfx.play("birth")

func _input(event):
	if _should_skip_actions():
		return

	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)

func _process(delta):
	pass

func _physics_process(delta):
	if _should_skip_actions():
		return

	_process_physics_action(delta)

func _should_skip_actions():
	return state == STATE_VICTORY or state == STATE_DYING or state == STATE_MATERIALIZING

func _process_physics_action(delta):
	var multiplier = 0

	# In order of priority for "just" presses. Otherwise, if both are held down,
	# uses the saved pushpull_dir to favor whichever came last.
	if Input.is_action_just_pressed("elfin_pull"):
		multiplier = 1
	elif Input.is_action_just_pressed("elfin_push"):
		multiplier = -1
	else:
		var pull = Input.is_action_pressed("elfin_pull")
		var push = Input.is_action_pressed("elfin_push")
		if pull and push:
			multiplier = 1 if pushpull_dir == "pull" else -1
		elif pull:
			multiplier = 1
		elif push:
			multiplier = -1
			
	pushpull_dir = "push" if multiplier < 0 else "pull"
	if multiplier != 0 and len(nearby_attractors) > 0:
		# A force is being applied. Calculate the force.
		_apply_force_to_attractors(multiplier)
	else:
		# Idle.
		var last_state = state
		state = STATE_IDLE
		if last_state == STATE_PUSHPULL:
			# We exited from pushpull.
			_update_based_on_mouse()

func _apply_force_to_attractors(multiplier):
	state = STATE_PUSHPULL
	multiplier = multiplier / float(len(nearby_attractors))

	for attractor in nearby_attractors:
		var force = (attractor.global_position - global_position).normalized()
		force *= FORCE
		force *= multiplier
		apply_impulse(Vector2(0, 0), force)
		
		if attractor is RigidBody2D:
			# Free anchor. Apply opposite force.
			attractor.apply_impulse(Vector2(0, 0), -force)

		_flip_sprite_based_on(attractor.global_position)

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

func finish_level():
	state = STATE_VICTORY
	sleeping = true
	nearby_attractors = []

func die():
	state = STATE_DYING
	sleeping = true
	nearby_attractors = []
	animation.play("death_explosion")
	sfx.play("death")
	camera.shake(0.5, 30, 6)

func _on_death_explosion_done():
	var level = get_tree().get_nodes_in_group("level")[0]
	level.begin_reset_transition()

func _on_birth_implosion_done():
	state = STATE_IDLE
	animation.play("idle")
	_update_based_on_mouse()