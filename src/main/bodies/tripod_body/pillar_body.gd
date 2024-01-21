extends CharacterBody2D

@export var main_body: PhysicsBody2D

func _on_input_event(viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Emit")
			main_body.emit_signal("input_event", viewport, event, _shape_idx)
	viewport.set_input_as_handled()
