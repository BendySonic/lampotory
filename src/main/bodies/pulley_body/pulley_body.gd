class_name PulleyBody
extends NormalBody

func _ready():
	super()
	connect("body_unheld", _on_body_unheld)

func _on_body_unheld(body: NormalBody):
	set_deferred("lock_rotation", true)
	collision_layer = 4225
	collision_mask = 4225

