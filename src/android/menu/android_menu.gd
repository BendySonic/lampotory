class_name AndroidMenu
extends Control
# Class for menu


const SAVE_DIR = "saves/"

@onready var gui_project_scene := preload("res://src/menu/gui/gui_project.tscn")

var PANEL
var WORKSPACE = "Panel/Menu/HBoxContainer/Workspace/"
var BUTTONS = "Panel/Menu/HBoxContainer/Buttons/"
var MY_PROJECT_GRID_CONTAINER = "Panel/Menu/HBoxContainer/Workspace/MyProjects/ScrollContainer/GridContainer"

@onready var buttons_container := get_node(BUTTONS)
@onready var new_button := get_node(BUTTONS + "NewButton")
@onready var my_projects_button := get_node(BUTTONS + "MyProjectsButton")

@onready var workspace_container := get_node(WORKSPACE)
@onready var new_container := get_node(WORKSPACE + "New")
@onready var new_grid_container := get_node(WORKSPACE + "New/MarginContainer/GridContainer")
@onready var my_projects_container := get_node(WORKSPACE + "MyProjects")
@onready var my_projects_grid_container := get_node(MY_PROJECT_GRID_CONTAINER)
@onready var settings_container := get_node(WORKSPACE + "Settings")


func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, false)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	#get_window().size = get_window().size * 0.7
	#get_window().position += Vector2i(200, 200)

#region Menu Pages
func _on_new_button_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		new_container.set_visible(true)

func _on_my_projects_button_toggled(button_pressed: bool):
	new_container.set_visible(false)
	if button_pressed:
		_set_invisible_containers()
		my_projects_container.set_visible(true)
		
		load_projects()

func _on_settings_button_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		settings_container.set_visible(true)

func _set_invisible_containers():
	for container in workspace_container.get_children():
		container.set_visible(false)
#endregion


#region New project
func _on_lab_pressed(object):
	Global.project_data["project_mode"] = object.mode
	get_tree().change_scene_to_file("res://src/main/loading/loading.tscn")
#endregion

#region Load projects
func load_projects():
	for gui_project in my_projects_grid_container.get_children():
		gui_project.queue_free()

	var file_names = DirAccess.get_files_at(SAVE_DIR)
	for file_name in file_names:
		var file = FileAccess.open(SAVE_DIR + file_name, FileAccess.READ)
		var save: Dictionary = file.get_var()
		var project_data = save["project_data"]
		
		var gui_project: GUIProject = gui_project_scene.instantiate()
		gui_project.project_data = project_data
		
		my_projects_grid_container.add_child(gui_project)
#endregion
