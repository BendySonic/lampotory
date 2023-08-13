#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#grid_widget.gd
#script for widget in menu grid in workspace interface
#################################
class_name GridWidget extends Control


#private variables
var res:BodyResource

var mouse_inside:bool = false

@onready var icon = get_node("VBoxContainer/TextureRect")
@onready var label = get_node("VBoxContainer/Label")

#private functions
func _on_gui_input(event):
	LampSignalManager.emit_signal("widget_input", event, self)


func set_view():
	icon.texture = res.body_icon
	label.text = res.widget_name["value_1"]


#public functions
func construct(res_arg:BodyResource):
	res = res_arg
	set_view()
