class_name BodyBase
extends CharacterBody2D
## Base class for ALL bodies

# -----------------------------------------------------------------------------
enum STATES {START, PLAY, PAUSE}
const BASE_PROPERTIES = ["base_text", "id", "name", "position", "data_text"]

var _data: BodyResource
var _properties: Dictionary # Start properties of body
var _realtime_properties: Dictionary # Realtime change of start properties
var _extra_properties: Array[String] # Subclass start properties
var _state = STATES.START
var _selected: bool = false

var mode_data: ModeResource  # Reference

@onready var select = get_node("Select")

# -----------------------------------------------------------------------------
func _ready():
	LampSignalManager.data_changed.connect(_on_data_change)


func _process(delta):
	move_and_collide(velocity * delta)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal("body_input", _properties, _data.id)


func _on_data_change(new_data, property_id, body_id):
	if _properties["id"] == body_id:
		_properties[property_id] = float(new_data)
		LampSignalManager.emit_signal("reload_pressed")


func _add_properties():
	for dictionary in mode_data.properties:
		if (
			_extra_properties.has(dictionary["id"])
			or BASE_PROPERTIES.has(dictionary["id"])
		):
			if dictionary["value_type"] != -1:
				if dictionary["vector"]:
					_properties[dictionary["id"]] = Vector2(0.0, 0.0)
				else:
					_properties[dictionary["id"]] = 0.0
			else:
				_properties[dictionary["id"]] = " "
	_realtime_properties = _properties.duplicate()


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


# Getters
func get_realtime_properties():
	return _realtime_properties


func get_properties():
	return _properties

func get_id():
	return _data.id
