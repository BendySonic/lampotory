extends Control

# -----------------------------------------------------------------------------
enum MODE {ONE_MECHANIC, TWO_MECHANIC}

@onready var workspace_instance = (
	preload("res://resources/scenes/main/main.tscn").instantiate()
)

# -----------------------------------------------------------------------------
func _init():
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(Vector2i(1100, 720))
	DisplayServer.window_set_position(
		(screen_size / 2) - Vector2i(550, 360)
	)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)

func _on_label_1d_gui_input(event):
	_open_workspace(MODE.ONE_MECHANIC)


func _on_label_2d_gui_input(event):
	_open_workspace(MODE.TWO_MECHANIC)


func _open_workspace(mode: int):
	workspace_instance.mode = mode
	get_tree().root.add_child(workspace_instance)
	queue_free()
