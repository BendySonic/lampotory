extends CharacterBody2D


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().emit_signal("input_event", viewport, event, shape_idx)
	viewport.set_input_as_handled()

func _mouse_enter():
	get_parent().emit_signal("mouse_entered")

func _mouse_exit():
	get_parent().emit_signal("mouse_exited")
