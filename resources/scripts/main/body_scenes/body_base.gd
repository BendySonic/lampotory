class_name BodyBase
extends CharacterBody2D
# Base class for ALL bodies


enum STATES {START, PLAY, PAUSE}
# Lists
var _base_properties: Array[String]
var _extra_base_properties: Array[String]
var _extra_base_realtime_properties: Array[String]
# Body data
var _data: BodyResource
var _state = STATES.START
var _selected: bool = false
# Mode data
var mode_data: ModeResource  # Reference

@onready var select = get_node("Select")


func _ready():
	_base_properties = [
	"data_text", "id", "type", "position", "behavior_text"
	]
	LampSignalManager.data_changed.connect(_on_data_change)


# Signals
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal(
					"body_input", _data.properties, _data.id
			)

func _on_data_change(new_data, property_id, body_id):
	if _data.properties["id"] == body_id:
		_data.properties[property_id] = float(new_data)
		LampSignalManager.emit_signal("reload_pressed")


# Inner methods
func _reload_properties():
	var properties = mode_data.properties
	for property in properties:
		if (
			_extra_base_properties.has(property)
			or _base_properties.has(property)
		):
			_data.properties[property] = properties[property]


func _reload_realtime_properties():
	var properties = mode_data.properties
	_data.realtime_properties = _data.properties.duplicate()
	for property in properties:
		if _extra_base_realtime_properties.has(property):
			_data.realtime_properties[property] = properties[property]

func _set_values():
	_data.properties["id"] = _data.id
	_data.properties["type"] = str(_data.widget_name)
	_data.properties["position"] = position.x


# Constructor for body
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
	_data.realtime_properties[property_name] = property_value
# Getters
func get_realtime_properties():
	return _data.realtime_properties

func get_properties():
	return _data.properties

func get_id():
	return _data.id
