class_name UIProperty
extends Control

# -----------------------------------------------------------------------------
enum MODES {MECHANIC_1D, MECHANIC_2D}
enum TYPES {STR, INT, VECTOR_STR, VECTOR_INT}

var _type: int = TYPES.STR
var _body_id: int
var _property_id: String
var _is_vector: bool

@onready var title_panel = get_node("PanelContainer2")
@onready var property_panel = get_node("PanelContainer")
@onready var title = get_node("PanelContainer2/MarginContainer/Label")
@onready var property = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer/Name"
)
@onready var x_edit = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer/ValueEdit"
)
@onready var x_label = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer/Coord"
)
@onready var y_edit = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer2/ValueEdit"
)
@onready var y_label = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer2/Coord"
)
@onready var x_value_label = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer/ValueLabel"
)
@onready var up_conatiner = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer"
)
@onready var down_container = get_node(
		"PanelContainer/MarginContainer/" +
		"VBoxContainer/HBoxContainer2"
)

# -----------------------------------------------------------------------------
func _on_x_edit_changed(new_text):
	_check_text(new_text, x_edit)


func _on_y_edit_changed(new_text):
	_check_text(new_text, y_edit)


func _on_line_edit_submitted(new_text):
	_send_text(x_edit.text, y_edit.text)


func _check_text(text: String, line_edit: LineEdit):
	if (
			(_type == TYPES.INT and Global.has_abc(text))
			or (_type == TYPES.STR and Global.has_123(text))
	):
		line_edit.delete_char_at_caret()


func _send_text(x_text: String, y_text: String):
	var result
	if _type == TYPES.INT:
		if _is_vector:
			result = Vector2(float(x_text), float(y_text))
		else:
			result = float(x_text)
	else:
		result = x_text
		
	LampSignalManager.emit_signal(
		"data_changed", result, _property_id, _body_id
	)


func construct(base_property: Dictionary, properties: Dictionary,
		property_name: String):
	# Title property.
	if base_property["value_type"] == -1:
		title_panel.visible = true
		title.text = base_property["name"]
		return 0
	# Simple property.
	property_panel.visible = true
	property.text = base_property["name"]
	_property_id = base_property["id"]
	_type = base_property["value_type"]
	_body_id = properties["id"]
	_is_vector = base_property["vector"]
	if base_property["can_change"]:
		if _is_vector:
			down_container.visible = true
			
			x_edit.visible = true
			x_label.visible = true
			x_edit.text = str(properties[property_name].x)
				
			y_edit.visible = true
			y_label.visible = true
			y_edit.text = str(properties[property_name].y)	
		else:
			x_edit.visible = true
			x_edit.text = str(properties[property_name])
	else:
		x_value_label.visible = true
		x_value_label.text = str(properties[property_name])
