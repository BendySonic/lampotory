class_name BodyBase extends CharacterBody2D


# Private variablse.
enum STATES {START, PLAY, PAUSE}

var state = STATES.START
var mode_data:ModeResource  # Reference
var base_properties:Array[String] = [ 
		"base_text", "id", "name",
		"position", "data_text"
]
# Public variable
var data:BodyResource
var properties:Dictionary


# Private methods.
func _ready():
	# Set signals
	LampSignalManager.data_changed.connect(on_data_change)


func _process(delta):
	move_and_collide(velocity * delta)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			LampSignalManager.emit_signal("body_input", properties)


func on_data_change(new_data, property_name, id):
	if properties["id"] == id:
		properties[property_name] = new_data
		
	else:
		return 0


# Public functions
func construct(data_arg:BodyResource, mode_data_arg:ModeResource):
	data = data_arg
	mode_data = mode_data_arg
