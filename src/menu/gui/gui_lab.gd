class_name GUILab
extends Container

signal selected(object)
signal deselected(object)

@export var mode: String

var toggled_on := false:
	set = set_toggled_on
@onready var choose_texture: Sprite2D = get_node("ChooseTexture")
@onready var choose_animation: AnimationPlayer = get_node("ChooseAnimationPlayer")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")


func _on_gui_lab_mouse_entered():
	animation.play("hover")

func _on_gui_lab_mouse_exited():
	animation.play_backwards("hover")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			toggled_on = not toggled_on

func set_toggled_on(value):
	toggled_on = value
	if value:
		choose_animation.play("choose")
		emit_signal("selected", self)
	else:
		choose_animation.play_backwards("choose")
		emit_signal("deselected", self)

func select():
	toggled_on = true

func deselect():
	toggled_on = false
