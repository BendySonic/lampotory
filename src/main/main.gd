extends Node
# Class of main workspace


const MODE_RESOURCE_PATH = "res://src/main/mode/resources/"
const MODES = ["mechanic_1d", "mechanic_2d"]
# Project mode (type of project to app editor)
var _mode := 0
var _mode_data: ModeResource
# Children
var gui: Node
var world: Node


func _enter_tree():
	gui = get_node("GUI")
	world = get_node("World")
	# Load mode data
	_mode_data = load(MODE_RESOURCE_PATH + MODES[_mode] + ".tres")
	for body_name in _mode_data.body_names:
		_mode_data.body_scenes[body_name] = (
				load(_mode_data.body_scene_path + body_name + ".tscn"))
	for body_name in _mode_data.body_names:
		_mode_data.body_resources[body_name] = (
				load(_mode_data.body_resource_path + body_name + ".tres"))
	_gui_api()
	_world_api()


# Children API
func _gui_api():
	# World
	gui.create_body = world.create_body
	gui.deselect_bodies = world.deselect_bodies
	gui.get_bodies = world.get_bodies
	gui.get_bodies_count = world.get_bodies_count
	# Main
	gui.get_mode_data = get_mode_data

func _world_api():
	# GUI
	world.create_properties = gui.create_properties
	world.delete_properties = gui.delete_properties
	world.block_workspace_area_input = gui.block_workspace_area_input
	# Main
	world.get_mode_data = get_mode_data
	world.is_mode = is_mode


# Getters
func get_mode_data() -> ModeResource:
	return _mode_data
# Conditions
func is_mode(mode_name: String) -> bool:
	return MODES[_mode] == mode_name


