class_name RopePart
extends RigidBody2D

var last_rope_part = null
@onready var shape = get_node("CollisionShape2D")


func _physics_process(delta):
	queue_redraw()

func _draw():
	if not last_rope_part == null:
		draw_line(to_local(last_rope_part.global_position), to_local(global_position), Color.LIME_GREEN, 6.0)


func get_pin_point():
	return get_node("PinPoint")

func set_shape(shape_arg: Shape2D):
	shape.shape = shape_arg

func set_weightless(value):
	if value:
		gravity_scale = 0.01
		linear_velocity = Vector2(0, 0)
	else:
		gravity_scale = 1
