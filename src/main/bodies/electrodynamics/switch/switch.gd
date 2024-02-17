class_name Switch
extends FloatNormalBody

var on := false

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			on = not on
			
			if on:
				animation.play("on")
			else:
				animation.play_backwards("on")
