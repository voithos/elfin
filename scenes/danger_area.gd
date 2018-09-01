extends Area2D

# Dangerous Area2D node.

func _ready():
	connect("body_entered", self, "_on_area_body_entered")

func _on_area_body_entered(body):
	# The only body that can match is the player.
	body.die()