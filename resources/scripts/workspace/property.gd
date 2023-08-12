#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#workspace.gd
#script for property in "properties" panel
#################################
class_name Property extends Control

enum TYPE {STR, INT}
var type:int = TYPE.STR
var body_id:int

@onready var title_panel = get_node("PanelContainer2")
@onready var property_panel = get_node("PanelContainer")

@onready var title = get_node("PanelContainer2/MarginContainer/Label")
@onready var property = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Name")
@onready var x_edit = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ValueEdit")
@onready var x_label = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Coord")
@onready var y_edit = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/ValueEdit2")
@onready var y_label = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Coord")

@onready var x_value_label = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ValueLabel")
@onready var up_conatiner = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer")
@onready var down_container = get_node("PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2")


func _on_value_edit_text_changed(new_text):
	if ( (type == TYPE.INT and LL.has_abc(new_text)) or
		(type == TYPE.STR and LL.has_123(new_text)) ):
		x_edit.delete_char_at_caret()


func _on_value_edit_text_submitted(new_text):
	var result
	if type == TYPE.INT:
		result = int(new_text)
	else:
		result = new_text
	LampSignalManager.emit_signal("data_changed", result, property.text, "value_x", body_id)


func _on_value_edit_2_text_changed(new_text):
	if ( (type == TYPE.INT and LL.has_abc(new_text)) or
		(type == TYPE.STR and LL.has_123(new_text)) ):
		y_edit.delete_char_at_caret()


func _on_value_edit_2_text_submitted(new_text):
	var result
	if type == TYPE.INT:
		result = int(new_text)
	else:
		result = new_text
	LampSignalManager.emit_signal("data_changed", result, property.text, "value_y", body_id)
