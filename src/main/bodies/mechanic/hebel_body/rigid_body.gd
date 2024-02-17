extends RigidBody2D

var data_to_save: PackedStringArray = [
	"rotation",
	"angular_velocity"
]

func _input_event(viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().emit_signal("input_event", viewport, event, _shape_idx)
	viewport.set_input_as_handled()
