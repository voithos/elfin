extends Sprite

onready var area = get_node("area")

func _ready():
	pass

func _on_area_body_entered(body):
	# The only body that can match is the player.
	# TODO: Actually complete the goal
	print("goal complete")
