#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#grid_widget.gd
#script for widget in menu grid in workspace interface
#################################
class_name GridWidget extends Control


#private variables
var object_name:String
var object_icon:Resource

var mouse_inside:bool = false


#private functions
func _on_gui_input(event):
	LampSignalManager.emit_signal("widget_input", event, self)

func set_icon(body_icon:Resource):
	$TextureRect.texture = body_icon


#public functions
func construct(body_name:String, body_icon:Resource):
	object_name = body_name
	object_icon = body_icon
	set_icon(object_icon)

func get_widget_name() -> String:
	return object_name
