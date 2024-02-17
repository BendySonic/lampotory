extends CharacterBody2D

signal unhold(tripod_height: Vector2)

var data_to_save: PackedStringArray = [
	"position"
]

var hold := false


func _physics_process(_delta):
	# Trupod level go to mouse in set axis
	if hold:
		velocity = Vector2(0, get_global_mouse_position().y - global_position.y) * 5
		move_and_slide()

func _on_input_event(viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				hold = true
	viewport.set_input_as_handled()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_released() and hold:
				hold = false
				emit_signal("unhold", position)
