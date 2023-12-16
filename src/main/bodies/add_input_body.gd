class_name AddInputBody
extends CharacterBody2D

func _input_event(viewport, event, shaped_idx):
	get_parent().emit_signal("input_event", viewport, event, shaped_idx)
