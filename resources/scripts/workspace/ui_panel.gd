class_name UIPanel
extends PanelContainer

# -----------------------------------------------------------------------------
var mouse_inside: bool = false

# -----------------------------------------------------------------------------
func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
	
#public functions
func is_mouse_inside() -> bool:
	return mouse_inside
