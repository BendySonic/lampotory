class_name ConnectArea
extends Area2D

var has_contact := false

func _physics_process(delta):
	var has_contact_arg := false
	for area in get_overlapping_areas():
		if area is ConnectArea and area.get_parent() == get_parent().connected_pin_point:
			has_contact_arg = true
	has_contact = has_contact_arg
