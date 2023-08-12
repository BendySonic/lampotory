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
var widget_name:String
var object_icon:Resource

var mouse_inside:bool = false

@onready var icon = get_node("VBoxContainer/TextureRect")
@onready var label = get_node("VBoxContainer/Label")

#private functions
func _on_gui_input(event):
	LampSignalManager.emit_signal("widget_input", event, self)

func set_view():
	icon.texture = object_icon
	label.text = widget_name


#public functions
func construct(res:BodyResource):
	object_name = res.body_name
	widget_name = res.widget_name["value_x"]
	object_icon = res.body_icon
	set_view()

func get_widget_name() -> String:
	return object_name
