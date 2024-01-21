extends Node2D

@export var main_body: NormalBody

var curve_points_positions: PackedVector2Array
var rope_parts: Array

@onready var rope_part := preload("res://src/main/bodies/rope_body/rope_part.tscn")
@onready var pin_point := preload("res://src/main/bodies/additional/pin_point/pin_point.tscn")
@onready var path_2d: Path2D = get_node("Path2D")

func _ready():
	main_body.connect("rigid_body_defined", _on_body_defined, CONNECT_ONE_SHOT)

func _on_body_defined():
	if curve_points_positions.is_empty():
		for i in range(0, path_2d.curve.point_count):
			curve_points_positions.push_back(path_2d.curve.get_point_position(i))
	
	var last_rope_part = null
	for curve_point_position in curve_points_positions:
		var new_rope_part = rope_part.instantiate()
		add_child(new_rope_part, true)
		new_rope_part.position = curve_point_position
		if not last_rope_part == null:
			new_rope_part.get_node("PinJoint2D").node_b = last_rope_part.get_path()
		new_rope_part.last_rope_part = last_rope_part
		last_rope_part = new_rope_part
		
		rope_parts.push_back(new_rope_part)
	
	
	var first_rope_part = rope_parts[0]
	var least_rope_part = rope_parts[rope_parts.size() - 1]
	
	# Set bigger forms
	var first_shape = first_rope_part.get_node("CollisionShape2D").shape
	first_rope_part.get_node("CollisionShape2D").shape = first_shape.duplicate()
	first_rope_part.get_node("CollisionShape2D").shape.radius = 15
	var second_shape = least_rope_part.get_node("CollisionShape2D").shape
	least_rope_part.get_node("CollisionShape2D").shape = first_shape.duplicate()
	least_rope_part.get_node("CollisionShape2D").shape.radius = 15
	
	# Set PinPoints
	var pin_point_a = pin_point.instantiate()
	pin_point_a.main_body = self
	pin_point_a.modulate = Color.SEA_GREEN
	pin_point_a.z_index = 10
	first_rope_part.add_child(pin_point_a)
	var pin_point_b = pin_point.instantiate()
	pin_point_b.main_body = self
	pin_point_b.modulate = Color.SEA_GREEN
	pin_point_b.z_index = 10
	least_rope_part.add_child(pin_point_b)

func _physics_process(delta):
	print(global_position)

func prepare_save():
	curve_points_positions = PackedVector2Array()
	var i: int = 0
	for rope_part in rope_parts:
		curve_points_positions.push_back(rope_part.position)
