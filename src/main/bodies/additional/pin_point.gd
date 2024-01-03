class_name PinPoint
extends Node2D

signal pin_point_connected()
signal pin_point_disconnected()

@export var parent_body: PhysicsBody2D:
	get = get_body
@export var main_body: NormalBody
var connected_pin_points: Array[PinPoint]
var has_connectable_bodies := false
	
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")
@onready var area: Area2D = get_node("Area2D")

func _ready():
	main_body.connect("body_unheld", _on_body_unheld)
	main_body.connect("body_held", _on_body_held)

func _physics_process(delta):
	has_connectable_bodies = area.has_overlapping_areas()

func _on_body_unheld(_body):
	connect_connectable_bodies()

func _on_body_held(_body):
	if not main_body.is_in_group("tripod"):
		disconnect_bodies()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				main_body.hold_body_with_pin()
	viewport.set_input_as_handled()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.is_pressed():
				main_body.unhold_body()

func connect_connectable_bodies():
	for area in area.get_overlapping_areas():
		if area.is_in_group("pin_point"):
			var pin_point = area.get_parent()
			if is_pin_point_connected(pin_point):
				continue
			connected_pin_points.push_back(area.get_parent())
			pin_point.connected_pin_points.push_back(self)
			pin_joint.node_a = pin_joint.get_path_to(parent_body)
			pin_joint.node_b = pin_joint.get_path_to(pin_point.get_body())
			
			pin_point.emit_signal("pin_point_connected")
			emit_signal("pin_point_connected")

func disconnect_bodies():
	for pin_point in connected_pin_points:
		pin_point.clear_pin_joint()
		pin_point.connected_pin_points.clear()
	clear_pin_joint()
	connected_pin_points.clear()

func clear_pin_joint():
	pin_joint.node_a = ""
	pin_joint.node_b = ""
	
func is_pin_point_connected(pin_point: PinPoint):
	return connected_pin_points.has(pin_point)

func get_body():
	return parent_body
