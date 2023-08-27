class_name BodyBase
extends CharacterBody2D
# Base class for ALL bodies

signal body_pressed(body_properties: Dictionary, body_id: int)

enum STATES {START, PLAY, PAUSE}
# Lists
var _base_properties: Array[String]
var _extra_base_properties: Array[String]
var _extra_base_realtime_properties: Array[String]
# Data
var _data: BodyResource
var _state: int = STATES.START
var _selected := false
var _mouse_inside := false
# Main
var get_mode_data: Callable
# World
var get_speed: Callable
var reload_world: Callable

@onready var select := get_node("Select")


func _ready():
	_base_properties = [
			"data_text", "id", "type",
			"position", "behavior_text"
	]
	Events.data_changed.connect(_on_data_change)
	input_event.connect(_on_input_event)
	mouse_entered.connect(func(): _mouse_inside = true)
	mouse_exited.connect(func(): _mouse_inside = false)


# Signals
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_pressed():
			body_pressed.emit(_data.properties, _data.id)

func _on_data_change(new_data, property_id: String, body_id: int):
	if _data.properties["id"] == body_id:
		_data.properties[property_id] = float(new_data)
		reload_world.call()


# Inner methods
func _reload_properties():
	var properties = get_mode_data.call().properties
	_data.properties = { }
	for property in _base_properties:
		_data.properties[property] = properties[property]
	for property in _extra_base_properties:
		_data.properties[property] = properties[property]

func _reload_realtime_properties():
	var properties = get_mode_data.call().properties
	_data.realtime_properties = _data.properties.duplicate()
	for property in _extra_base_realtime_properties:
		_data.realtime_properties[property] = properties[property]

func _set_values():
	_data.properties["id"] = _data.id
	_data.properties["type"] = str(_data.widget_name)
	_data.properties["position"] = position.x


# Constructor for body
func construct(data_arg: BodyResource):
	_data = data_arg
# Body select
func select_body():
	_selected = true
	select.visible = true
	z_index = 5

func deselect_body():
	_selected = false
	select.visible = false
	z_index = 0


# Setters
func set_realtime_property(property_name: String, property_value):
	_data.realtime_properties[property_name] = property_value
# Getters
func get_realtime_property(property_name: String) -> Variant:
	if _data.realtime_properties.has(property_name):
		return _data.realtime_properties[property_name]
	else:
		return "?"

func get_property(property_name: String) -> Variant:
	if _data.properties.has(property_name):
		return _data.properties[property_name]
	else:
		return "?"

func get_properties() -> Dictionary:
	return _data.properties

func get_id() -> int:
	return _data.id

func is_selected() -> bool:
	return _selected

func is_mouse_inside() -> bool:
	return _mouse_inside
