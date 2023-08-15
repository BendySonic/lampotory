class_name Menu
extends Node2D

# -----------------------------------------------------------------------------
enum MODE {ONE_MECHANIC, TWO_MECHANIC}

@onready var workspace_instance = (
	preload("res://resources/scenes/workspace/workspace.tscn").instantiate()
)

# -----------------------------------------------------------------------------
func _on_label_1d_gui_input(event):
	_open_workspace(MODE.ONE_MECHANIC)


func _on_label_2d_gui_input(event):
	_open_workspace(MODE.TWO_MECHANIC)


func _open_workspace(mode: int):
	workspace_instance.mode = mode
	get_tree().root.add_child(workspace_instance)
	queue_free()
