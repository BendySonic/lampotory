class_name RulerBody
extends NormalBody

var precise_mode: bool:
	set = set_precise_mode

@onready var shape = get_node("CollisionShape2D")

func _on_body_unheld(body):
	linear_velocity = Vector2(0, 0)

func _draw():
	var shape_meter_size = 4
	var grid_offset = Vector2(-205, -30)
	for i in range(0, shape_meter_size + 1):
		# Arrow
		var arrow_pos = Vector2(i * 100, 0) + grid_offset
		draw_line(arrow_pos, arrow_pos + Vector2(0, 20), Color.WHITE, 5)
		# Label
		var label = Label.new()
		label.text = str(i)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.modulate = Color.WHITE
		label.size = Vector2(20, 10)
		var half_label_size = label.size.x / 2
		label.position = arrow_pos + Vector2(-half_label_size, 20)
		add_child(label)
		if i ==  shape_meter_size:
			break
		for j in range(1, 10):
			var small_arrow_pos = arrow_pos + Vector2(j * 10, 0)
			draw_line(small_arrow_pos, small_arrow_pos + Vector2(0, 10), Color.WHITE_SMOKE, 2.5)

func set_precise_mode(value):
	precise_mode = value
	if value:
		input_component.rotate_speed = 1
	else:
		input_component.rotate_speed = 5
