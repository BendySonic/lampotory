class_name SpringComponent
extends DampedSpringJoint2D

enum SpringType {DYNAMOMETER, NORMAL}

@export var length_coeff: float = 6
@export var width_coeff: float = 17
@export var skew_coeff: float = 2.5
@export var ring_count: float = 5

@export var spring_type: SpringType

var arrow_value: float = 0

func _physics_process(delta):
	queue_redraw()

func _draw():
	# Spring
	var length = get_node(node_b).position.length()
	var length_coeff = clamp(((length * 0.1) - 11) * 2.8, 1, 30)
	for i in range(1, ring_count):
		var points: PackedVector2Array = [
				Vector2(-width_coeff, i * length_coeff), 
				Vector2(width_coeff, (i - 1) * length_coeff + skew_coeff * 2),
				Vector2(width_coeff, (i - 1) * length_coeff + skew_coeff * 3), 
				Vector2(-width_coeff, i * length_coeff + skew_coeff)
		]
		draw_colored_polygon(points, Color(0, 0.704, 0.347))
	for i in range(0, ring_count):
		var points: PackedVector2Array = [
				Vector2(-width_coeff, i * length_coeff), 
				Vector2(width_coeff, i * length_coeff + skew_coeff * 2),
				Vector2(width_coeff, i * length_coeff + skew_coeff * 3), 
				Vector2(-width_coeff, i * length_coeff + skew_coeff)
		]
		draw_colored_polygon(points, Color(0, 0.904, 0.547))
		if i == ring_count - 1:
			arrow_value = i * length_coeff + skew_coeff * 3
	
	# Rope
	draw_line(
			Vector2(0, arrow_value),
			Vector2(0, get_node(node_b).position.y),
			Color(0, 0.704, 0.347),
			3.0
	)
	# Arrow
	draw_line(
			Vector2(-8, arrow_value),
			Vector2(width_coeff, arrow_value),
			Color(0, 0.904, 0.547),
			3.0
	)

func is_spring_type(spring_type_arg: SpringType):
	return spring_type == spring_type_arg
