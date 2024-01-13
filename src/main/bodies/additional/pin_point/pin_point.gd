class_name PinPoint
extends Node2D

signal pin_point_connected()
signal moved_to_connect()
signal pin_point_disconnected()

@export var main_body: NormalBody
@export var disconnect_on_hold: bool

var connected_pin_point_path: NodePath
var connected_pin_point: PinPoint
var is_connected := false
var has_connect := false

var is_move_to_connect := false
	
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")
@onready var detect_area: DetectArea = get_node("DetectArea")
@onready var connect_area: ConnectArea = get_node("ConnectArea")
@onready var input_component: InputComponent = get_node("InputComponent")

func _ready():
	main_body.connect("rigid_body_defined", _on_main_body_defined)
	main_body.connect("body_unheld", _on_body_unheld)
	main_body.connect("body_static_held", _on_static_body_held)

func _on_main_body_defined():
	if is_connected:
		connected_pin_point = get_node(connected_pin_point_path)
		connect_pin_point(connected_pin_point)

func _physics_process(delta):
	if connect_area.has_contact:
		is_move_to_connect = false
		emit_signal("moved_to_connect")
	if is_move_to_connect:
		main_body.set_velocity(
				(connected_pin_point.global_position - self.global_position) * 20
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
			
			connect_pin_point(pin_point)
			
			connected_pin_point = pin_point
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
		main_body.collision_layer = 0
		main_body.collision_mask = 0
		await moved_to_connect
		pin_joint.node_a = pin_joint.get_path_to(get_parent())
		pin_joint.node_b = pin_joint.get_path_to(pin_point.get_parent())
		main_body.collision_layer = 1
		main_body.collision_mask = 1

func disconnect_pin_points():
	for area in detect_area.get_overlapping_areas():
		if area is DetectArea:
			var pin_point = area.get_parent()
			
			if pin_point.connected_pin_point == self:
				pin_point.clear()
			
			is_move_to_connect = false
			pin_point.emit_signal("pin_point_disconnected")
			emit_signal("pin_point_disconnected")
			break
	clear()

func clear():
	pin_joint.node_a = ""
	pin_joint.node_b = ""
	connected_pin_point_path = NodePath("")
	connected_pin_point = null
	is_connected = false
	has_connect = false

func move_to_connect():
	is_move_to_connect = true

func get_main_body():
	return main_body
