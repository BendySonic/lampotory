class_name UIProperty extends Control

enum MODES {MECHANIC_1D, MECHANIC_2D}
var mode:int
enum TYPE {STR, INT, VECTOR_STR, VECTOR_INT}
var type:int = TYPE.STR
var body_id:int
var is_vector:bool

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


func construct(
	base_property:Dictionary, properties:Dictionary, property_name:String):
	# Title property.
	if base_property["value_type"] == -1:
		title_panel.visible = true
		title.text = base_property["name"]
		return 0
	# Simple property.
	property_panel.visible = true
	property.text = base_property["name"]
	type = base_property["value_type"]
	body_id = properties["id"]
	if base_property["vector"]:
		down_container.visible = true
		
		x_edit.visible = true
		x_label.visible = true
		x_edit.text = str(properties[property_name].x)
			
		y_edit.visible = true
		y_label.visible = true
		y_edit.text = str(properties[property_name].y)
	else:
		if base_property["can_change"]:
			x_edit.visible = true
			x_edit.text = str(properties[property_name])
		else:
			x_value_label.visible = true
			x_value_label.text = str(properties[property_name])


func _on_value_edit_text_changed(new_text):
	if ( (type == TYPE.INT and LL.has_abc(new_text)) or
		(type == TYPE.STR and LL.has_123(new_text)) ):
		x_edit.delete_char_at_caret()


func _on_value_edit_text_submitted(new_text):
	var result
	if type == TYPE.INT:
		result = float(new_text)
	else:
		result = new_text
	LampSignalManager.emit_signal("data_changed", result, property.text, body_id)


func _on_value_edit_2_text_changed(new_text):
	if ( (type == TYPE.INT and LL.has_abc(new_text)) or
		(type == TYPE.STR and LL.has_123(new_text)) ):
		y_edit.delete_char_at_caret()


func _on_value_edit_2_text_submitted(new_text):
	var result
	if type == TYPE.INT:
		result = float(new_text)
	else:
		result = new_text
	LampSignalManager.emit_signal("data_changed", result, property.text, body_id)
