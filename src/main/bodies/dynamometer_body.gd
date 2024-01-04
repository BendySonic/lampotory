class_name DynamometerBody
extends NormalBody

@export var length_coeff: float = 8
@export var width_coeff: float = 15
@export var skew_coeff: float = 3.5
@export var ring_count: float = 4

var arrow_value: float = 0

@export var level_position: Vector2

@onready var place_holder = get_node("PlaceHolder")

func _ready():
	super()
	if is_loaded:
		place_holder.position = level_position

func _physics_process(delta):
	level_position = place_holder.position
	queue_redraw()

#func _input(event):
#	super(event)
#	if event is InputEventMouseButton:
#		if event.button_index == 2:
#			if event.is_pressed():
#				print(arrow_value)

func _draw():
	# Spring
	var length = place_holder.position.length()
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
			Vector2(0, place_holder.position.y),
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

