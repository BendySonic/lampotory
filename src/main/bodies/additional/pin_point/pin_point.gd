class_name PinPoint
extends Node2D

signal pin_point_connected()
signal moved_to_connect()
signal pin_point_disconnected()

@export var main_body: NormalBody
@export var data_to_save: PackedStringArray = [
		"connected_pin_point_path",
		"is_connected",
		"has_connect"
]
@export var disconnect_on_hold: bool

var connected_pin_point_path: NodePath
var connected_pin_point: PinPoint
# Connect another body
var is_connected := false
# Connected by another body
var has_connect := false

var is_move_to_contact := false
	
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")
@onready var detect_area: DetectArea = get_node("DetectArea")
@onready var connect_area: ConnectArea = get_node("ConnectArea")
@onready var input_component: InputComponent = get_node("InputComponent")

func _ready():
	if not main_body == null:
		main_body.connect("rigid_body_defined", _on_main_body_defined, CONNECT_ONE_SHOT)
		main_body.connect("body_unheld", _on_body_unheld)
		main_body.connect("body_static_held", _on_static_body_held)

func _on_main_body_defined():
	if is_connected:
		while connected_pin_point == null:
			connected_pin_point = get_node(connected_pin_point_path)
		connect_pin_point(connected_pin_point)

func _physics_process(delta):
	if connect_area.has_contact:
		is_move_to_contact = false
		emit_signal("moved_to_connect")
	if is_move_to_contact:
		main_body.set_velocity(
				(connected_pin_point.global_position - self.global_position) * 15
		)

func _on_static_body_held(_body):
	if disconnect_on_hold:
		disconnect_pin_points()

func _on_body_unheld(_body):
	connect_pin_points()

func connect_pin_points():
	for area in detect_area.get_overlapping_areas():
		if area is DetectArea:
			var pin_point = area.get_parent()
			
			if pin_point.connected_pin_point == self:
				continue
			
			connected_pin_point = pin_point
			await connect_pin_point(pin_point)
			connected_pin_point_path = get_path_to(pin_point)
			is_connected = true
			pin_point.has_connect = true
			break

func connect_pin_point(pin_point: PinPoint):
	if (
			(not is_connected and not pin_point.is_connected)
			or (is_connected and main_body.is_loaded)
	):
		move_to_connect()
		var layer_arg = main_body.collision_layer
		var mask_arg = main_body.collision_mask
		main_body.set_collision_to_pin_point_connect()
		await moved_to_connect
		pin_joint.node_a = pin_joint.get_path_to(get_parent())
		pin_joint.node_b = pin_joint.get_path_to(pin_point.get_parent())
		main_body.collision_layer = layer_arg
		main_body.collision_mask = mask_arg

func disconnect_pin_points():
	is_move_to_contact = false
	
	for area in detect_area.get_overlapping_areas():
		if area is DetectArea:
			var pin_point = area.get_parent()
			
			if pin_point.is_connected or pin_point.has_connect:
				pin_point.clear()
			
				pin_point.emit_signal("pin_point_disconnected")
				emit_signal("pin_point_disconnected")
	clear()

func clear():
	pin_joint.node_a = ""
	pin_joint.node_b = ""
	connected_pin_point_path = NodePath("")
	connected_pin_point = null
	is_connected = false
	has_connect = false

func disconnect_cursor():
	if Global.cursor.is_hold(get_parent()):
		Global.cursor.unhold_body()

func move_to_connect():
	is_move_to_contact = true

func get_main_body():
	return main_body
	
func prepare_save():
	pass
