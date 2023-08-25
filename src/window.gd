extends Control
# Class for window app

# Scenes
@onready var menu_scene := preload("res://src/menu/menu.tscn")
@onready var main_scene := preload("res://src/main/main.tscn")
# Nodes
@onready var sub_viewport := get_node("Window/SubViewportContainer/" +
		"SubViewport")


func _init():
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(Vector2i(1100, 720))
	DisplayServer.window_set_position(
		(screen_size / 2) - Vector2i(550, 360)
	)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)


func _ready():
	_change_scene(menu_scene)


func _change_scene(packed_scene: PackedScene):
	if LampLib.has_child(sub_viewport):
		for child in sub_viewport.get_children():
			child.queue_free()
	sub_viewport.add_child(packed_scene.instantiate())
