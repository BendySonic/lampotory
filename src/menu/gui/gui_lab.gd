class_name GUILab
extends Container

signal create_pressed(object)

@export var mode: String

var pressed := false

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")

@onready var label = get_node("VBox/Label")

func _on_gui_lab_mouse_entered():
	animation.play("hover")

func _on_gui_lab_mouse_exited():
	animation.play_backwards("hover")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed = not pressed
			if pressed:
				animation.play("show")
			else:
				animation.play_backwards("show")


func _on_create_pressed():
	emit_signal("create_pressed", self)

func _on_mouse_entered():
	animation.queue("hover")

func _on_mouse_exited():
	animation.queue("rehover")
