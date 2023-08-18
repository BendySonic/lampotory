class_name GUIGridWidget
extends Control

# -----------------------------------------------------------------------------
var data: BodyResource

@onready var icon = get_node("VBoxContainer/TextureRect")
@onready var label = get_node("VBoxContainer/Label")

# -----------------------------------------------------------------------------
func _on_gui_input(event):
	LampSignalManager.emit_signal("widget_input", event, self)


func _set_view():
	icon.texture = data.body_icon
	label.text = data.widget_name


func construct(data_arg: BodyResource):
	data = data_arg
	_set_view()
