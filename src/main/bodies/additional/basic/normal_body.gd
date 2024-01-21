class_name NormalBody
extends RigidBodyPlus
# Base class for bodies in laboratory
# Note: class uses RigidBodyPlus instead of RigidBody2D

signal body_static_held(body: NormalBody)
signal body_pin_held(body: NormalBody)
signal body_unheld(body: NormalBody)
signal body_selected(body: NormalBody)
signal body_deselected(body: NormalBody)
signal data_edited(property_name: String, value: Variant)
signal data_changed()

enum States {NORMAL, STATIC_HOLD, PIN_HOLD, SELECTED}
enum Player {PLAY, PAUSE}

static var count: int = 0

# Data
@export var properties: Dictionary
var state: States = States.NORMAL
var player: Player = Player.PLAY
# Loadable
@export var body_scene_path: String
# Save system
var save_data: Dictionary
var is_loaded := false
# Nodes
@onready var select := get_node("Visuals/Select") as Node2D
# Components
@onready var save_component: SaveComponent = get_node("SaveComponent")
@onready var input_component: InputComponent = get_node("InputComponent")



#region Initialization
func create_body():
	self.properties = properties.duplicate()

func create_copy_body(properties_arg: Dictionary):
	self.properties = properties_arg.duplicate()

func load_body(save_data_arg: Dictionary):
	self.is_loaded = true
	self.save_data = save_data_arg

func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		count += 1
	elif what == NOTIFICATION_PREDELETE:
		count -= 1

func _ready():
	save_component.load_data(save_data, self)
	prepare_body()
	connect("data_edited", _on_data_edited)
	connect("rigid_body_defined", _on_body_defined, CONNECT_ONE_SHOT)

func _input(event):
	if event is InputEventMouseButton:
		# Rotation
		if event.button_index == 4:
			if event.is_pressed():
				if is_state(States.STATIC_HOLD) and not is_in_group("tripod"):
					var rotated_tf = physics_state.transform.rotated_local(0.393)
					physics_state.transform = rotated_tf
		elif event.button_index == 5:
			if event.is_pressed():
				if  is_state(States.STATIC_HOLD) and not is_in_group("tripod"):
					var rotated_tf = physics_state.transform.rotated_local(-0.393)
					physics_state.transform = rotated_tf

func _on_data_edited(property_name: String, value: Variant):
	set_property(property_name, value)
	reload_data()
	emit_signal("data_changed")

func _on_body_defined():
	reload_data()
#endregion


#region Ready methods
func prepare_body():
	set_start_position()

func set_start_position():
	if not is_loaded:
		self.global_position = Global.cursor.global_position
#endregion


#region States
func set_state(value: States):
	state = value

func is_state(state_arg: States) -> bool:
	return state == state_arg

func set_player(value: Player):
	player = value

func is_player(player_arg: Player) -> bool:
	return player == player_arg
#endregion


#region Hold
func hold_body():
	input_component.hold_body()

func unhold_body():
	input_component.unhold_body()

func set_static_hold():
	set_state(States.STATIC_HOLD)
	emit_signal("body_static_held", self)

func set_pin_hold():
	set_state(States.PIN_HOLD)
	emit_signal("body_pin_held", self)

func set_unhold():
	set_state(States.NORMAL)
	emit_signal("body_unheld", self)

func is_held() -> bool:
	return (is_state(States.STATIC_HOLD) or is_state(States.PIN_HOLD))
#endregion

#region Select
func select_body():
	input_component.select_body()

func deselect_body():
	input_component.deselect_body()

func set_select():
	set_state(States.SELECTED)
	emit_signal("body_selected", self)

func set_deselect():
	set_state(States.NORMAL)
	emit_signal("body_deselected", self)

func is_selected() -> bool:
	return is_state(States.SELECTED)
#endregion


#region Data
func reload_data():
	for property_name in get_properties():
		if property_name in self:
			self.set(property_name, get_property(property_name))
		elif property_name in physics_state:
			physics_state.set(property_name, get_property(property_name))
	sleeping = false

func set_property(property_name: String, value: Variant):
	properties[property_name] = value

func get_property(property_name: String) -> Variant:
	return properties[property_name]

func get_properties() -> Dictionary:
	return properties

func get_id() -> String:
	return properties["id"]
#endregion

func set_velocity(direction: Vector2):
	if body_defined:
		physics_state.set_linear_velocity(direction)

#region Save/Load body
func save_body():
	return save_component.save_data()

func prepare_save():
	pass
#endregion



