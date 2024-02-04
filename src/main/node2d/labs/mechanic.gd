extends Node2D
# Class for foreground (enviroment) of laboratory

@export var shape_meter_size: int

var is_mouse_inside: bool

@onready var shape = get_node("StaticBody2D/CollisionShape2D")


func _on_static_body_2d_mouse_entered():
	is_mouse_inside = true

func _on_static_body_2d_mouse_exited():
	is_mouse_inside = false

func _draw():
	var arrow_x_offset = Vector2(0, -500)
	var arrow_y_offset = Vector2(0, -2500)
	for i in range(-shape_meter_size, shape_meter_size + 1):
		# Arrow
		var arrow_pos = Vector2(i * 100, 0) + arrow_x_offset
		draw_line(arrow_pos, arrow_pos + Vector2(0, 20), Color.WEB_GRAY, 5)
		# Small arrow
		if not i == shape_meter_size:
			for j in range(1, 10):
				var small_arrow_pos = arrow_pos + Vector2(j * 10, 0)
				draw_line(small_arrow_pos, small_arrow_pos + Vector2(0, 10), Color.GRAY, 2.5)
		# Grid
		var line_pos_x = Vector2(i * 100, 0) + arrow_x_offset
		draw_line(line_pos_x, line_pos_x - Vector2(0, 4000), Color(0.9, 0.9, 0.9), 2)
		var line_pos_y = Vector2(-2000, i * 100) + arrow_y_offset
		draw_line(line_pos_y, line_pos_y + Vector2(4000, 0), Color(0.9, 0.9, 0.9), 2)
		# Arrow label
		var label = Label.new()
		label.text = str(i)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.label_settings = LabelSettings.new()
		label.label_settings.font_size = 40
		label.size = Vector2(20, 10)
		var half_label_size = label.size.x / 2
		label.position = arrow_pos + Vector2(-half_label_size, 7)
		label.pivot_offset += label.size / 2
		label.scale /= 2
		label.modulate = Color.WEB_GRAY
		
		add_child(label)
	# Info Label
	var label = Label.new()
	label.text = "m, μ=0.4"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 40
	label.size = Vector2(20, 10)
	label.position = Vector2(-label.size.x / 2, -440)
	label.pivot_offset += label.size / 2
	label.scale /= 2
	label.modulate = Color.WEB_GRAY
	add_child(label)
