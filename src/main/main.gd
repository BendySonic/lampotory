class_name Main
extends Node
# Class of Main
# Description: Contains laboratory main editor
# Note: Main has Node2D and GUI components

# Mode of laboratory
var mode_data: ModeResource:
	get: return mode_data

# Child nodes
var gui: Node
var node2d: Node

var change_scene_to: Callable



# Private functions
func init(call_arg: Callable, mode_arg: ModeResource):
	self.change_scene_to = call_arg
	self.mode_data = mode_arg
	
func _enter_tree():
	_load_children()
	
# Note: items are controls of bodies in editor,
#		you select items to spawn bodies
# Note: play/reload are signals to manipulate simulation
func _ready():
	gui.connect("item_pressed", _on_item_pressed)
	gui.connect("item_released", _on_item_released)
	gui.connect("items_window_mouse_exited", _on_items_window_mouse_exited)
	gui.connect("play_toggled", _on_play_toggled)
	gui.connect("reload_pressed", _on_reload_pressed)
	
	gui.create_items(mode_data.item_resources)
	
	node2d.connect("void_pressed", _on_void_pressed)
	node2d.connect("body_held", _on_body_held)
	node2d.connect("body_unheld", _on_body_unheld)
	node2d.connect("body_selected", _on_body_selected)
	node2d.connect("body_deselected", _on_body_deselected)

func _on_item_pressed(item_data: ItemResource):
	clear_select()
	node2d.set("selected_item_data", item_data)

func _on_item_released():
	clear_select()
	node2d.unhold_held_body()
	node2d.set("selected_item_data", null)

func _on_items_window_mouse_exited():
	var selected_item_data = node2d.get("selected_item_data")
	if not selected_item_data == null:
		node2d.create_body(selected_item_data).hold_body()
		node2d.set("selected_item_data", null)

func _on_play_toggled(button_pressed: bool):
	node2d.play(button_pressed)

func _on_reload_pressed():
	node2d.reload()

func _on_void_pressed():
	clear_select()

func _on_body_held(body: BodyBase):
	clear_select()

func _on_body_unheld(body: BodyBase):
	clear_select()

func _on_body_selected(body: BodyBase):
	gui.create_properties(body)

func _on_body_deselected(body: BodyBase):
	gui.delete_properties()

func _load_children():
	gui = get_node("GUI")
	node2d = get_node("Node2D")


# Public functions
func is_mode(mode_name: String) -> bool:
	return mode_data.mode_name == mode_name

func clear_select():
	node2d.deselect_selected_body()
	gui.delete_properties()

