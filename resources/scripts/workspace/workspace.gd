class_name Workspace
extends Node2D
## Class of app Workspace
## Data layer

# -----------------------------------------------------------------------------
const MODE_RESOURCE_PATH = "res://resources/scenes/workspace/mode_resources/"
const MODES = ["mechanic_1d", "mechanic_2d"]

var mode: int = 0
var mode_data: ModeResource

@onready var ui = $UI/UI
@onready var objects = $Objects

# -----------------------------------------------------------------------------
func _ready():
	ui.workspace = self
	objects.workspace = self
	
	mode_data = load(MODE_RESOURCE_PATH + MODES[mode] + ".tres")
	
	for body_name in mode_data.body_names:
		mode_data.body_scenes[body_name] = (
				load(mode_data.body_scene_path + body_name + ".tscn"))
	
	for body_name in mode_data.body_names:
		mode_data.body_resources[body_name] = (
				load(mode_data.body_resource_path + body_name + ".tres"))
	
	ui.create_grid_widgets(mode_data)
