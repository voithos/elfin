extends RigidBody2D

onready var sprite = get_node("sprite")

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)

func _handle_mouse_motion(event):
	sprite.flip_h = global_position.x > event.position.x