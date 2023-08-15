class_name BodyBase
extends CharacterBody2D

# -----------------------------------------------------------------------------
enum STATES {START, PLAY, PAUSE}
const BASE_PROPERTIES = ["base_text", "id", "name", "position", "data_text"]

var _data:BodyResource
var _properties:Dictionary
var _state = STATES.START

var mode_data:ModeResource  # Reference

# -----------------------------------------------------------------------------
func _ready():
	# Set signals
	LampSignalManager.data_changed.connect(_on_data_change)


func _process(delta):
	move_and_collide(velocity * delta)


func construct(data_arg: BodyResource, mode_data_arg: ModeResource):
	_data = data_arg
	mode_data = mode_data_arg


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			LampSignalManager.emit_signal("body_input", _properties)


func _on_data_change(new_data, property_id, id):
	if _properties["id"] == id:
		_properties[property_id] = new_data
		LampSignalManager.emit_signal("reload_pressed")
