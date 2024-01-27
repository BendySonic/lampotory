class_name GUIProperty
extends Control
# Class for single property in property window

const PROPERTY = "EditProperty/MarginContainer/PropertyContainer/"
const NAME = PROPERTY + "Name"
const VALUE = PROPERTY + "Value/"

var body: NormalBody

var property_name: String
var property_value: Variant

@onready var theme_resource = preload("res://assets/godot/themes/white.tres")

@onready var name_label := get_node(NAME) as Label
@onready var value_container := get_node(VALUE) as HBoxContainer
var value_edit: Variant



func create_property(body_arg: NormalBody,
		property_name_arg: String, property_value_arg: Variant):
	self.body = body_arg
	self.property_name = property_name_arg
	self.property_value = property_value_arg

func _ready():
	if property_value is int or property_value is float:
		value_edit = SpinBox.new()
		if property_value is int:
			value_edit.set_step(1)
		elif property_value is float:
			value_edit.set_step(0.01)
		value_edit.connect("value_changed", _on_value_changed)
		if property_name == "friction":
			value_edit.max_value = 1
			value_edit.min_value = 0
		else:
			value_edit.max_value = 300
		value_edit.set_value(property_value)
	elif property_value is bool:
		value_edit = CheckButton.new()
		value_edit.connect("toggled", _on_value_toggled)
		value_edit.button_pressed = property_value
	elif property_value is Vector2:
		print("Property is Vector2 type. Warning!")
	
	value_edit.set_theme(theme_resource)
	value_container.add_child(value_edit)
	name_label.set_text(tr(property_name))

func _on_value_changed(value: Variant):
	body.emit_signal("data_edited", property_name, value)

func _on_value_toggled(toggled_on: bool):
	body.emit_signal("data_edited", property_name, toggled_on)
