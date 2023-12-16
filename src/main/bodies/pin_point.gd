class_name PinPoint
extends Node2D

var body: NormalBody:
	get = get_body
var has_connectable_bodies := false
	
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")
@onready var area: Area2D = get_node("Area2D")

func _physics_process(delta):
	has_connectable_bodies = area.has_overlapping_areas()

func connect_connectable_bodies():
	for area in area.get_overlapping_areas():
		if area.is_in_group("pin_point"):
			pin_joint.node_a = pin_joint.get_path_to(body)
			pin_joint.node_b = pin_joint.get_path_to(area.get_parent().get_body())
	
func get_body():
	return body
