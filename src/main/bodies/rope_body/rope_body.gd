class_name RopeBody
extends Node2D

@export var main_body: NormalBody
@export var length_limit: float = 100

# Loadable
var curve_points_positions: PackedVector2Array

var rope_parts: Array
var end_rope_parts: Array

@onready var rope_part_scene := preload(
		"res://src/main/bodies/rope_body/rope_part.tscn"
)
@onready var pin_point_scene := preload(
		"res://src/main/bodies/additional/pin_point/pin_point.tscn"
)
@onready var input_component_scene := preload(
		"res://src/main/bodies/additional/components/input_component.tscn"
)
@onready var path_2d: Path2D = get_node("Path2D")



func _ready():
	main_body.connect("rigid_body_defined", _on_body_defined, CONNECT_ONE_SHOT)

func _on_body_defined():
	if curve_points_positions.is_empty():
		for i in range(0, path_2d.curve.point_count):
			curve_points_positions.push_back(path_2d.curve.get_point_position(i))
	
	var last_rope_part
	for curve_point_position in curve_points_positions:
		var new_rope_part = rope_part_scene.instantiate()
		new_rope_part.position = curve_point_position
		new_rope_part.last_rope_part = last_rope_part
		call_deferred("set_child", new_rope_part, last_rope_part)
		await new_rope_part.ready
		rope_parts.push_back(new_rope_part)
		
		last_rope_part = new_rope_part
	set_pin_points()

func set_pin_points():
	# First and last rope parts settings
	var first_rope_part = rope_parts[0]
	var last_rope_part = rope_parts[rope_parts.size() - 1]
	end_rope_parts  = [first_rope_part, last_rope_part]
	for rope_part in end_rope_parts:
		rope_part.set_deferred("lock_rotation", true)
		# Set bigger forms
		var shape = RectangleShape2D.new()
		shape.size = Vector2(25, 25)
		shape.custom_solver_bias = 1
		rope_part.set_shape(shape)
		# Set PinPoint
		var pin_point_instance = pin_point_scene.instantiate()
		pin_point_instance.main_body = main_body
		pin_point_instance.modulate = Color.SEA_GREEN
		pin_point_instance.z_index = 10
		# Set PinPoint's InputComponent
		var input_component_instance = input_component_scene.instantiate()
		input_component_instance.input_body = rope_part
		input_component_instance.set_pin_hold_type()
		
		pin_point_instance.add_child(input_component_instance, true)
		rope_part.add_child(pin_point_instance, true)

func _physics_process(delta):
	# Length imit
	for end_rope_part in end_rope_parts:
		var pin_point = end_rope_part.get_pin_point()
		if end_rope_part.position.length() > length_limit:
			end_rope_part.get_pin_point().disconnect_pin_points()
			pin_point.disconnect_cursor()

func prepare_save():
	curve_points_positions = PackedVector2Array()
	for rope_part in rope_parts:
		curve_points_positions.push_back(rope_part.position)

func set_child(new_rope_part, last_rope_part):
	if last_rope_part:
		new_rope_part.get_node("PinJoint2D").node_b = last_rope_part.get_path()
		
	add_child(new_rope_part, true)

func set_weightless(value):
	for rope_part in rope_parts:
		rope_part.set_weightless(value)
