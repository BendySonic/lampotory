extends TextureRect

@export var tooltip: String

@onready var panel = get_node("PanelContainer")
@onready var label = get_node("PanelContainer/Label")

func _ready():
	label.text = tooltip

func _on_mouse_exited():
	panel.set_visible(false)


func _on_gui_input(event):
	print("WTH")
	if event is InputEventMouseButton:
		if event.is_pressed():
			panel.set_visible(true)


func _on_mouse_entered():
	print("WEEWWD")
