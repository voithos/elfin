extends CanvasLayer

signal unfade_complete
signal fade_complete

export (bool) var start_immediately = true

onready var sprite = get_node("sprite")
onready var animation = get_node("animation")

func _ready():
	add_to_group("transition")
	
	if start_immediately:
		sprite.frame = 16
		begin_unfade()
	else:
		sprite.frame = 0

# Unfade animation is started immediately.

func begin_unfade():
	animation.play("unfade")

func begin_fade():
	sprite.show()
	animation.play("fade")

func _on_unfade_complete():
	sprite.hide()
	emit_signal("unfade_complete")

func _on_fade_complete():
	emit_signal("fade_complete")