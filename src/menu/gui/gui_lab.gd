class_name GUILab
extends Container

signal create_pressed(object)

@export var mode: String
@export var icon: Texture2D
@export_multiline var tooltip: String

var pressed := false

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
@onready var texture: TextureRect = get_node("VBox/TextureRect/TextureRect/Margin/TextureRect")
@onready var label: Label = get_node("VBox/Label")
@onready var tooltip_label: Label = get_node("VBox/TextureRect/PanelContainer/VBoxContainer/Label")


func _ready():
	texture.texture = icon
	label.text = mode
	tooltip_label.text = tooltip

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
