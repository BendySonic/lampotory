extends Node2D
# Class for foreground (enviroment) of laboratory

var is_mouse_inside: bool

@onready var shape = get_node("StaticBody2D/CollisionShape2D")


func _on_static_body_2d_mouse_entered():
	is_mouse_inside = true

func _on_static_body_2d_mouse_exited():
	is_mouse_inside = false

func _draw():
	var shape_meter_size = 10
	var grid_offset = Vector2(0, -500)
	for i in range(-shape_meter_size, shape_meter_size + 1):
		# Arrow
		var arrow_pos = Vector2(i * 100, 0) + grid_offset
		draw_line(arrow_pos, arrow_pos + Vector2(0, 20), Color.WEB_GRAY, 5)
		# Label
		var label = Label.new()
		label.text = str(i)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.modulate = Color.WEB_GRAY
		label.size = Vector2(20, 10)
		var half_label_size = label.size.x / 2
		label.position = arrow_pos + Vector2(-half_label_size, 20)
		add_child(label)
		if i == shape_meter_size:
			break
		for j in range(1, 10):
			var small_arrow_pos = arrow_pos + Vector2(j * 10, 0)
			draw_line(small_arrow_pos, small_arrow_pos + Vector2(0, 10), Color.GRAY, 2.5)
	# Info Label
	var label = Label.new()
	label.text = "m, μ=0.4"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 20
	label.modulate = Color.WEB_GRAY
	label.size = Vector2(20, 10)
	label.position = Vector2(-label.size.x / 2, -440)
	add_child(label)
