#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#grid_widget.gd
#script for widget in menu grid in workspace interface
#################################
class_name grid_widget extends Control

#private variables
var object_name:String

var mouse_inside:bool = false
var event_type:InputEventMouse
var follow_mouse:bool = false


#private functions
func _process(delta):
	if follow_mouse:
		global_position = get_global_mouse_position() - Vector2(16, 16)

func _on_gui_input(event):
	event_type = event

func _on_mouse_entered():
	mouse_inside = true
	
func _on_mouse_exited():
	mouse_inside = false
	
func set_label(argName:String):
	$Label.text = argName

#public functions
func construct(argName:String):
	object_name = argName
	set_label(argName)

func is_mouse_inside():
	return mouse_inside
	
func get_info():
	return object_name
	
func set_follow_mouse():
	follow_mouse = true
