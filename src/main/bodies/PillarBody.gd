extends CharacterBody2D

func _input_event(viewport, event, shaped_idx):
	print("me")
	get_parent().emit_signal("input_event", viewport, event, shaped_idx)
