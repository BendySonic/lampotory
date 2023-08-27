class_name GUIGridWidget
extends Control


signal widget_pressed(grid_widget: GUIGridWidget)
signal widget_released(grid_widget: GUIGridWidget)

# Body data
var _data: BodyResource

@onready var icon = get_node("VBoxContainer/TextureRect")
@onready var label = get_node("VBoxContainer/Label")


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			widget_pressed.emit(self)
		else:
			widget_released.emit(self)

func _set_view():
	icon.texture = _data.body_icon
	label.text = _data.widget_name


func construct(data_arg: BodyResource):
	_data = data_arg
	_set_view()

func get_data():
	return _data
