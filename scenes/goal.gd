extends Sprite

onready var area = get_node("area")
onready var particles = get_node("particles")
onready var sfx = get_node("/root/sfx")

func _ready():
	particles.emitting = false

func _on_area_body_entered(body):
	# The only body that can match is the player.
	body.finish_level()
	particles.emitting = true
	sfx.play("goal")

	var level = get_tree().get_nodes_in_group("level")[0]
	level.begin_next_level_transition()