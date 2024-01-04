class_name Main
extends Node
# Class for Main
# Contains laboratory main editor


# Project mode
var mode_data: ModeResource = preload("res://src/main/modes/mechanic.tres"):
	get: return mode_data

# Children
var gui: Node
var node2d: Node


#region Initialization
func _enter_tree():
	gui = get_node("GUI")
	node2d = get_node("Node2D")

func _ready():
	gui.connect("item_pressed", _on_item_pressed)
	gui.connect("item_released", _on_item_released)
	gui.connect("items_window_mouse_exited", _on_items_window_mouse_exited)
	
	gui.connect("play_toggled", _on_play_toggled)
	gui.connect("reload_pressed", _on_reload_pressed)
	
	gui.connect("copy_pressed", _on_copy_pressed)
	gui.connect("cut_pressed", _on_cut_pressed)
	gui.connect("paste_pressed", _on_paste_pressed)
	gui.connect("delete_pressed", _on_delete_pressed)
	
	gui.connect("save_project_pressed", _on_save_project_pressed)
	gui.connect("open_project_pressed", _on_open_project_pressed)
	
	gui.create_items(mode_data.item_resources)
	
	node2d.connect("void_pressed", _on_void_pressed)
	node2d.connect("body_held", _on_body_held)
	node2d.connect("body_unheld", _on_body_unheld)
	node2d.connect("body_selected", _on_body_selected)
	node2d.connect("body_deselected", _on_body_deselected)

func _clear_select():
	node2d.clear_select()
	gui.clear_select()
#endregion


#region Input
func _on_item_pressed(item_data: ItemResource):
	_clear_select()
	node2d.item_pressed(item_data)

func _on_item_released():
	node2d.item_released()

func _on_items_window_mouse_exited():
	node2d.create_body()

func _on_play_toggled(button_pressed: bool):
	node2d.play(button_pressed)

func _on_reload_pressed():
	node2d.reload()

func _on_copy_pressed():
	node2d.copy_body()

func _on_cut_pressed():
	node2d.copy_body()
	node2d.delete_selected_body()
	_clear_select()

func _on_paste_pressed():
	node2d.paste_body()

func _on_delete_pressed():
	node2d.delete_selected_body()
	_clear_select()

func _on_save_project_pressed(name: String, theme: String):
	node2d.save_project(name, theme)

func _on_open_project_pressed():
	node2d.load_project()

func _on_body_held(_body: NormalBody):
	_clear_select()

func _on_body_unheld(_body: NormalBody):
	_clear_select()

func _on_body_selected(body: NormalBody):
	gui.create_actions_with_body(body)
	gui.create_properties(body)
	#pass

func _on_body_deselected(_body: NormalBody):
	gui.delete_actions()
	gui.delete_properties()

func _on_void_pressed(event):
	_clear_select()
	if event.button_index == 2:
		gui.create_actions(node2d.get_cursor())
#endregion


#region Mode
func is_mode(mode_name: String) -> bool:
	return mode_data.mode_name == mode_name
#endregion
