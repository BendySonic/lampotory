class_name BodyBase
extends RigidBodyPlus
# Base class for bodies in laboratory
# Note: class uses RigidBodyPlus class instead of RigidBody2D

signal body_held(body: BodyBase)
signal body_unheld(body: BodyBase)
signal body_selected(body: BodyBase)
signal body_deselected(body: BodyBase)
signal data_edited(property_name: String, value: Variant)
signal data_changed()

enum States {NORMAL, HOLD, SELECTED}
enum Player {PLAY, PAUSE}

static var count: int = 0

var can_unhold := false:
	set = set_can_unhold

var _state: States = States.NORMAL
var _player: Player = Player.PLAY
var _body_data: BodyResource = BodyResource.new()

@onready var select := get_node("Select") as MeshInstance2D
@onready var area := get_node("Area2D") as Area2D



# Private
func init(item_data_arg: ItemResource, position_arg: Vector2):
	self._body_data.properties = item_data_arg.base_properties.duplicate()
	self._body_data.edit_properties = item_data_arg.edit_properties.duplicate()
	self.transform = Transform2D(Vector2(1 ,0), Vector2(0 ,1), position_arg)

func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		count += 1
	elif what == NOTIFICATION_PREDELETE:
		count -= 1

func _ready():
	super()
	input_event.connect(_on_input_event)
	body_defined.connect(_on_body_defined, CONNECT_ONE_SHOT)
	data_edited.connect(_on_data_edited)

func _integrate_forces(state):
	super(state)
	if _is_state(States.HOLD):
		physics_state.set_linear_velocity(
				(get_global_mouse_position() - global_position) * 25
		)

func _physics_process(delta):
	if _is_state(States.HOLD):
		set_can_unhold(not area.has_overlapping_bodies())

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4:
			if event.is_pressed():
				if _is_state(States.HOLD):
					var rotated_tf = physics_state.transform.rotated_local(0.393)
					physics_state.transform = rotated_tf
		elif event.button_index == 5:
			if event.is_pressed():
				if  _is_state(States.HOLD):
					var rotated_tf = physics_state.transform.rotated_local(-0.393)
					physics_state.transform = rotated_tf	
		
		if event.button_index == 1:
			if not event.is_pressed():
				if is_body_held() and _is_state(States.HOLD):
					unhold_body()
					emit_signal("body_unheld", self)

# Signals
func _on_input_event(_viewport: Node, event: Variant, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				if not _is_state(States.HOLD):
					hold_body()
					emit_signal("body_held", self)
		elif event.button_index == 2:
			if event.is_pressed():
				if not _is_state(States.HOLD):
					if _is_state(States.SELECTED):
						deselect_body()
						emit_signal("body_deselected", self)
					else:
						select_body()
						emit_signal("body_selected", self)

# Data edited through properties window
func _on_data_edited(property_name: String, value: Variant):
	set_property(property_name, value)
	emit_signal("data_changed")

# Body full defined (with all states and methods)
func _on_body_defined():
	#var transform_arg = Transform2D(Vector2(1 ,0), Vector2(0 ,1), position)
	#set_property("transform", transform_arg)
	set_property("id", "name" + str(count))


# State methods
func _set_state(value: States):
	_state = value

func _is_state(state_arg: States) -> bool:
	return _state == state_arg

func _set_player(value: Player):
	_player = value

func _is_player(player_arg: Player) -> bool:
	return _player == player_arg


# Interface methods
func hold_body():
	deselect_body()
	_set_state(States.HOLD)
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, false)
	# Visual effect
	modulate = Color(0.663, 0.804, 1)
	z_index = 5

func unhold_body():
	if _is_state(States.HOLD):
		_set_state(States.NORMAL)
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		physics_state.linear_velocity = Vector2(0, 0)
		# Visual effect
		modulate = Color(1, 1, 1)
		z_index = 1

func set_can_unhold(value: bool):
	if value:
		modulate = Color(0.663, 0.804, 1)
	else:
		modulate = Color(1, 0.169, 0.18)
	can_unhold = value

func is_body_held() -> bool:
	return _state == States.HOLD

func select_body():
	unhold_body()
	_set_state(States.SELECTED)
	# Visual select
	select.visible = true
	z_index = 5

func deselect_body():
	if _is_state(States.SELECTED):
		_set_state(States.NORMAL)
		# Visual deselect
		select.visible = false
		z_index = 0

func is_selected() -> bool:
	return _is_state(States.SELECTED)


# Data methods
func reload_data():
	for property_name in get_properties():
		if property_name in physics_state:
			physics_state.set(property_name, get_property(property_name))
		if property_name in self:
			self.set(property_name, get_property(property_name))

func set_property(property_name: String, value: Variant):
	_body_data.properties[property_name] = value
	if get_edit_properties().has(property_name):
		_body_data.edit_properties[property_name] = value
	reload_data()

func get_property(property_name: String) -> Variant:
	return _body_data.properties[property_name]

func get_properties() -> Dictionary:
	return _body_data.properties	

func get_edit_properties() -> Dictionary:
	return _body_data.edit_properties

func get_id() -> String:
	return _body_data.properties["id"]
