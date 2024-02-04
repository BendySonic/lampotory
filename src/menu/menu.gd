class_name Menu
extends Control
# Class for menu


const SAVE_DIR = "saves/"

const BUTTONS = "Panel/Panel/Menu/Menu/Menu/Buttons/"
const WORKSPACE = "Panel/Panel/Workspace/"

@onready var gui_project_scene := preload("res://src/menu/gui/gui_project.tscn")

@onready var panel: PanelContainer = get_node("Panel")

@onready var buttons_container := get_node(BUTTONS)
@onready var new_button := get_node(BUTTONS + "NewButton")
@onready var my_projects_button := get_node(BUTTONS + "MyProjectsButton")

@onready var workspace_container := get_node(WORKSPACE)
@onready var new_container := get_node(WORKSPACE + "New")
@onready var new_grid_container := get_node(WORKSPACE + "New/MarginContainer/GridContainer")
@onready var my_projects_container := get_node(WORKSPACE + "MyProjects")
@onready var my_projects_grid_container := get_node(WORKSPACE + "MyProjects/ScrollContainer/GridContainer")


func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, false)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	for child in new_grid_container.get_children():
		child.connect("selected", _on_lab_selected)
		child.connect("deselected", _on_lab_deselected)

func _set_invisible_containers():
	for container in workspace_container.get_children():
		container.set_visible(false)

func _physics_process(delta):
	workspace_container.queue_sort()
	panel.queue_sort()


# Menu Pages
func _on_new_button_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		new_container.set_visible(true)

func _on_my_projects_button_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		my_projects_container.set_visible(true)
		
		load_projects()


# New project
func _on_lab_selected(object):
	Global.project_data["project_mode"] = object.mode
	for child in new_grid_container.get_children():
		if not child == object and child.toggled_on:
			child.deselect()

func _on_lab_deselected(object):
	if Global.project_data["project_mode"] == object.mode:
		Global.project_data["project_mode"] = ""

func _on_create_project_pressed():
	if not Global.project_data["project_mode"] == "":
		get_tree().change_scene_to_file("res://src/main/loading/loading.tscn")


# Load projects
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
