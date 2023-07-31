#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#panel.gd
#script for panel in workspace interface
#################################
class_name panel extends PanelContainer

#private variables
var mouse_inside:bool = false

#private functions
func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
	
#public functions
func is_mouse_inside():
	return mouse_inside
