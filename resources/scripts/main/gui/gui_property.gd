class_name GUIProperty
extends Control

# -----------------------------------------------------------------------------
var _body_id: int
var _property_id: String
var _property_value: Variant
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
	check_text(new_text, x_edit)

func _on_y_edit_changed(new_text):
	check_text(new_text, y_edit)

func _on_line_edit_submitted(_new_text):
	send_text(x_edit.text, y_edit.text)


# Check text for numbers and letters
func check_text(text: String, line_edit: LineEdit):
	if (
			(_property_value is int and LampLib.has_abc(text))
			or (_property_value is String and LampLib.has_123(text))
	):
		line_edit.delete_char_at_caret()

# Send text like String/Vector2/float
func send_text(x_text: String, y_text: String):
	var result
	if _property_value is int:
		if _is_vector:
			result = Vector2(float(x_text), float(y_text))
		else:
			result = float(x_text)
	else:
		result = x_text
	
	LampSignalManager.emit_signal(
		"data_changed", result, _property_id, _body_id
	)


func construct(body_properties: Dictionary,
		body_property: String, local_ru: Dictionary):
	# Title property.
	if body_property == "data_text" or body_property == "behavior_text":
		title_panel.visible = true
		title.text = body_properties[body_property]
		return 0
	# Simple property.
	property_panel.visible = true
	property.text = local_ru[body_property]
	
	_property_id = body_property
	_property_value = body_properties[body_property]
	_body_id = body_properties["id"]
	_is_vector = body_properties[body_property] is Vector2
	
	if body_properties[body_property] is String:
		x_value_label.visible = true
		x_value_label.text = str(_property_value)
	else:
		if _is_vector:
			down_container.visible = true
			
			x_edit.visible = true
			x_label.visible = true
			x_edit.text = str(_property_value.x)
				
			y_edit.visible = true
			y_label.visible = true
			y_edit.text = str(_property_value.y)	
		else:
			x_edit.visible = true
			x_edit.text = str(_property_value)
