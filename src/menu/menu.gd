class_name Menu
extends Control
# Class for menu


const SAVE_DIR = "saves/"

const BUTTONS = "Panel/Panel/Menu/Menu/Menu/Buttons/"
const WORKSPACE = "Panel/Panel/Workspace/"


@onready var gui_project_scene := preload("res://src/menu/gui/gui_project.tscn")

@onready var buttons_container := get_node(BUTTONS)
@onready var new_button := get_node(BUTTONS + "NewButton")
@onready var my_projects_button := get_node(BUTTONS + "MyProjectsButton")

@onready var workspace_container := get_node(WORKSPACE)
@onready var new_container := get_node(WORKSPACE + "New")
@onready var my_projects_container := get_node(WORKSPACE + "MyProjects")
@onready var my_projects_grid_container := get_node(WORKSPACE + "MyProjects/ScrollContainer/GridContainer")

func _init():
	print("EOROR")

# TODO - Develop create project window
func _set_invisible_containers():
	for container in workspace_container.get_children():
		container.set_visible(false)


func _on_new_button_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		new_container.set_visible(true)

func _on_my_projects_button_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		my_projects_container.set_visible(true)
		
		load_projects()


func _on_mechanic_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Global.project_data = {
					"project_name": "",
					"project_theme": "",
					"project_mode": "",
					"is_saved": false
			}
			Global.project_data["project_mode"] = "mechanic"
			get_tree().change_scene_to_file("res://src/main/main.tscn")

func load_projects():
	var file_names = DirAccess.get_files_at(SAVE_DIR)
	for file_name in file_names:
		print(file_names)
		var file = FileAccess.open(SAVE_DIR + file_name, FileAccess.READ)
		var save: Dictionary = file.get_var()
		var project_data = save["project_data"]
		
		var gui_project: GUIProject = gui_project_scene.instantiate()
		gui_project.project_data = project_data
		
		my_projects_grid_container.add_child(gui_project)
