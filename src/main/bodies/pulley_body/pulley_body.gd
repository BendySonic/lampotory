class_name PulleyBody
extends NormalBody

var weightless: bool = false:
	set = set_weightless

@onready var rope_body: RopeBody = get_node("RopeBody")


func _on_body_unheld(body: NormalBody):
	set_deferred("lock_rotation", true)
	collision_layer = 4225
	collision_mask = 4225

func set_weightless(value):
	weightless = value
	rope_body.set_weightless(value)

func set_collision_to_pin_point_connect():
	collision_layer = 4224
	collision_mask = 4224
	
