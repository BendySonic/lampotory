class_name GUIProperty
extends Control
# Class for single property in property window

const PROPERTY = "EditProperty/MarginContainer/PropertyContainer/"
const NAME = PROPERTY + "Name"
const VALUE = PROPERTY + "Value/"

var body: NormalBody

var _property_name: String
var _property_value: Variant

@onready var theme_resource = preload("res://assets/godot/themes/white.tres")

@onready var name_label := get_node(NAME) as Label
@onready var value_container := get_node(VALUE) as HBoxContainer
var value_edit: Variant



func init(body_arg: NormalBody,
		property_name_arg: String, property_value_arg: Variant):
	self.body = body_arg
	self._property_name = property_name_arg
	self._property_value = property_value_arg

func _ready():
	value_edit = SpinBox.new()
	
	if _property_value is int or _property_value is float:
		value_edit = SpinBox.new()
		if _property_value is int:
			value_edit.set_step(1)
		else:
			value_edit.set_step(0.01)
	elif _property_value is Vector2:
		print("Property is Vector2 type. Warning!")
	
	value_edit.set_theme(theme_resource)
	value_edit.connect("value_changed", _on_value_changed)
	value_container.add_child(value_edit)
	
	name_label.set_text(tr(_property_name))
	value_edit.set_value(_property_value)

func _on_value_changed(value: Variant):
	body.emit_signal("data_edited", _property_name, value)
