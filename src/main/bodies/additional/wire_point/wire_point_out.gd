class_name WirePointOut
extends StaticBody2D


@export var main_body: NormalBody

var connected_wire_point_in_path: NodePath
var connected_wire_point_in: WirePointIn
# Connect another body
var is_connected := false

var hold := false


func _physics_process(delta):
	queue_redraw()

func _draw():
	if hold:
		draw_square_wire(Vector2(0, 0), to_local(get_global_mouse_position()))
	if is_connected and not hold:
		draw_square_wire(Vector2(0, 0), to_local(connected_wire_point_in.global_position))

func draw_square_wire(start: Vector2, end: Vector2):
	#var x
	#var y
	#if abs(end.x) > abs(end.y):
	#	x = end.x
	#	y = 0
	#else:
	#	x = 0
	#	y = end.y
	
	draw_line(
				start,
				end,
				Color(0, 0.704, 0.347),
				5.0
	)
	#draw_line(
	#			Vector2(x, y),
	#			end,
	#			Color(0, 0.704, 0.347),
	#			5.0
	#)
	#draw_circle(end, 6, Color(0, 0.704, 0.347))

func _input(event):
	if event is InputEventMouseButton:
		if event.is_released() and hold:
			hold = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			disconnect_all()
			hold = true
			Global.wire_source = self
	viewport.set_input_as_handled()


func connect_to(wire_target: WirePointIn):
	is_connected = true
	wire_target.has_connect = true
	connected_wire_point_in = wire_target
	connected_wire_point_in_path = wire_target.get_path()

func disconnect_all():
	is_connected = false
	connected_wire_point_in = null
	connected_wire_point_in_path = NodePath("")

