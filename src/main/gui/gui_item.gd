class_name GUIItem
extends Control
# Class for item in items window
# Note: Items window keep controls (items) of bodies to choose and spawn

signal item_pressed(item_data: ItemResource)
signal item_released()

var item_data: ItemResource:
	get: return item_data

@onready var icon = get_node("MarginContainer/VBoxContainer/TextureRect")
@onready var label = get_node("MarginContainer/VBoxContainer/Label")



func init(item_data_arg: ItemResource):
	self.item_data = item_data_arg

func _ready():
	label.text = item_data.item_name
	icon.texture = item_data.item_icon
	icon.modulate = item_data.item_modulate

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				emit_signal("item_pressed", item_data)
			else:
				emit_signal("item_released")
