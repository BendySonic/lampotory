class_name NormalBody
extends RigidBodyPlus
# Base class for bodies in laboratory
# Note: class uses RigidBodyPlus instead of RigidBody2D

signal body_held(body: NormalBody)
signal body_held_with_pin(body: NormalBody)
signal body_unheld(body: NormalBody)
signal body_selected(body: NormalBody)
signal body_deselected(body: NormalBody)
signal data_edited(property_name: String, value: Variant)
signal data_changed()

enum States {NORMAL, HOLD, SELECTED}
enum Player {PLAY, PAUSE}

static var count: int = 0

#var can_unhold := false
	#set = set_can_unhold
	
@export var state: States = States.NORMAL
@export var player: Player = Player.PLAY
@export var body_data: BodyResource = BodyResource.new()

@export var cursor_path: NodePath
@export var body_scene_path: String

var cursor: GUICursor:
	get = get_cursor
var body_scene: PackedScene

var is_loaded: bool

@onready var select := get_node("Select") as Node2D
@onready var area := get_node("Area2D") as Area2D


# There is many HACK's, sorry for this... I had no time... So dumb code...
# Mainly it caused by bug with saving references to nodes in PackedScene

#region Initialization
func init(cursor_arg: GUICursor, body_scene: PackedScene):
	self.cursor_path = cursor_arg.get_path()
	self.body_scene_path = body_scene.resource_path
	self.is_loaded = false
	self.body_data = body_data.duplicate()

func init_as_copy(cursor_arg: GUICursor, body_scene: PackedScene,
		properties: Dictionary, edit_properties: Dictionary):
	self.cursor_path = cursor_arg.get_path()
	self.body_scene_path = body_scene.resource_path
	self.is_loaded = false
	self.body_data.properties = properties
	self.body_data.edit_properties = edit_properties

func init_as_loaded():
	self.is_loaded = true

func _notification(what):
	if what == NOTIFICATION_POSTINITIALIZE:
		count += 1
	elif what == NOTIFICATION_PREDELETE:
		count -= 1

func _ready():
	cursor = get_node(cursor_path)
	body_scene = ResourceLoader.load(body_scene_path)
	# Position to cursor
	if not is_loaded and not is_in_group("tripod"):
		self.global_position = cursor.global_position
	# Fix freeze trouble after load project
	if freeze:
		linear_velocity = Vector2(0, 0)
	
	connect("input_event", _on_input_event)
	connect("data_edited", _on_data_edited)
	connect("rigid_body_defined", _on_body_defined, CONNECT_ONE_SHOT)

#func _physics_process(_delta):
	#if _is_state(States.HOLD) and body_defined:
		# Can unhold
		#can_unhold = not area.has_overlapping_areas()

func _input(event):
	if event is InputEventMouseButton:
		# Rotation
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
		# Hold
		if event.button_index == 1:
			if not event.is_pressed():
				if _is_state(States.HOLD):
					unhold_body()

func _on_input_event(viewport: Node, event: Variant, _shape_idx: int):
	print("Event")
	if event is InputEventMouseButton:
		# Hold
		if event.button_index == 1:
			if event.is_pressed():
				if not _is_state(States.HOLD):
					hold_body()
					viewport.set_input_as_handled()
		# Select
		elif event.button_index == 2:
			if event.is_pressed():
				if _is_state(States.SELECTED):
					deselect_body()
				else:
					select_body()

func _on_data_edited(property_name: String, value: Variant):
	set_property(property_name, value)
	load_data()
	emit_signal("data_changed")

func _on_body_defined():
	set_property("id", "name" + str(count))
	load_data()
	print("Body defined")
#endregion


#region States
func _set_state(value: States):
	state = value

func _is_state(state_arg: States) -> bool:
	return state == state_arg

func _set_player(value: Player):
	player = value

func _is_player(player_arg: Player) -> bool:
	return player == player_arg
#endregion


#region Hold
func hold_body():
	_set_state(States.HOLD)
	deselect_body()
	cursor.hold_body(self)
	set_deferred("lock_rotation", true)
	# Visual effect
	modulate = Color(0.663, 0.804, 1)
	
	emit_signal("body_held", self)

func hold_body_with_pin():
	_set_state(States.HOLD)
	deselect_body()
	cursor.hold_body(self)
	# Visual effect
	modulate = Color(0.663, 0.804, 1)
	
	emit_signal("body_held_with_pin", self)

func unhold_body():
	if _is_state(States.HOLD):
		_set_state(States.NORMAL)
		cursor.unhold_body()
		set_deferred("lock_rotation", false)
		# Visual effect
		modulate = Color(1, 1, 1)
		
		emit_signal("body_unheld", self)

func is_held() -> bool:
	return state == States.HOLD

#func set_can_unhold(value: bool):
	#if value:
		#modulate = Color(0.663, 0.804, 1)
	#else:
		#modulate = Color(1, 0.169, 0.18)
	#can_unhold = value
#endregion


#region Select
func select_body():
	if not _is_state(States.HOLD):
		_set_state(States.SELECTED)
		# Visual select
		select.visible = true
		#z_index = 5
		
		emit_signal("body_selected", self)

func deselect_body():
	if _is_state(States.SELECTED):
		_set_state(States.NORMAL)
		# Visual deselect
		select.visible = false
		#z_index = 0
		
		emit_signal("body_deselected", self)

func is_selected() -> bool:
	return _is_state(States.SELECTED)
#endregion


#region Data
func load_data():
	for property_name in get_properties():
		if property_name in self:
			self.set(property_name, get_property(property_name))
		elif property_name in physics_state:
			physics_state.set(property_name, get_property(property_name))
	sleeping = false

func set_property(property_name: String, value: Variant):
	body_data.properties[property_name] = value
	# Sync data properties and editable properties
	if get_edit_properties().has(property_name):
		body_data.edit_properties[property_name] = value

func get_property(property_name: String) -> Variant:
	return body_data.properties[property_name]

func get_properties() -> Dictionary:
	return body_data.properties

func get_edit_properties() -> Dictionary:
	return body_data.edit_properties

func get_id() -> String:
	return body_data.properties["id"]
#endregion

func set_velocity(direction: Vector2):
	if body_defined:
		physics_state.set_linear_velocity(direction)

func get_cursor():
	return cursor



func _on_area_2d_input_event(viewport, event, shape_idx):
	viewport.set_input_as_handled()
