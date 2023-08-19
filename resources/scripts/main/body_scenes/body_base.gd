class_name BodyBase
extends CharacterBody2D
## Base class for ALL bodies

# -----------------------------------------------------------------------------
enum STATES {START, PLAY, PAUSE}
# Class properties lists
const BASE_PROPERTIES = ["base_text", "id", "name", "position", "data_text"]
# Subclass properties lists
var _extra_base_properties: Array[String]
var _extra_base_realtime_properties: Array[String]
# Class properties
var _properties: Dictionary # Class start properties (static)
var _realtime_properties: Dictionary # Class realtime properties (dynamic)
var _data: BodyResource
var _state = STATES.START
var _selected: bool = false

var mode_data: ModeResource  # Reference

@onready var select = get_node("Select")

# -----------------------------------------------------------------------------
func _ready():
	LampSignalManager.data_changed.connect(_on_data_change)


# Signals
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal("body_input", _properties, _data.id)

func _on_data_change(new_data, property_id, body_id):
	if _properties["id"] == body_id:
		_properties[property_id] = float(new_data)
		LampSignalManager.emit_signal("reload_pressed")


# Inner methods
func _reload_properties():
	for dictionary in mode_data.properties:
		if (
			_extra_base_properties.has(dictionary["id"])
			or BASE_PROPERTIES.has(dictionary["id"])
		):
			if dictionary["value_type"] != -1:
				if dictionary["vector"]:
					_properties[dictionary["id"]] = Vector2(0.0, 0.0)
				else:
					_properties[dictionary["id"]] = 0.0
			else:
				_properties[dictionary["id"]] = " "

func _reload_realtime_properties():
	_realtime_properties = _properties.duplicate()
	for dictionary in mode_data.realtime_properties:
		if (
			_extra_base_realtime_properties.has(dictionary["id"])
		):
			_realtime_properties[dictionary["id"]] = 0.0

func _set_values():
	_properties["id"] = _data.id
	_properties["name"] = _data.widget_name
	_properties["position"] = position.x


# Constructor
func construct(data_arg: BodyResource, mode_data_arg: ModeResource):
	_data = data_arg
	mode_data = mode_data_arg


# Body select
func select_body():
	_selected = true
	select.visible = true

func deselect_body():
	_selected = false
	select.visible = false


# Setters
func set_realtime_property(property_name: String, property_value):
	_realtime_properties[property_name] = property_value

# Getters
func get_realtime_properties():
	return _realtime_properties

func get_properties():
	return _properties

func get_id():
	return _data.id
