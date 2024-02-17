class_name WirePointIn
extends StaticBody2D

# Connected by another body
var has_connect := false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_released() and not Global.wire_source == null:
			Global.wire_source.connect_to(self)
