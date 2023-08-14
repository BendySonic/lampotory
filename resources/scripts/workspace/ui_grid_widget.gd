class_name UIGridWidget extends Control

# Private variables.
var data:BodyResource
var mouse_inside:bool = false

@onready var icon = get_node("VBoxContainer/TextureRect")
@onready var label = get_node("VBoxContainer/Label")


# Private methods
func _on_gui_input(event):
	LampSignalManager.emit_signal("widget_input", event, self)


func set_view():
	icon.texture = data.body_icon
	label.text = data.widget_name


# Public methods
func construct(data_arg:BodyResource):
	data = data_arg
	set_view()
