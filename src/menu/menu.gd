extends Control
# Class for menu


const BUTTONS = "Panel/Panel/Menu/Menu/Menu/Buttons/"
const WORKSPACE = "Panel/Panel/Workspace/"

@onready var gui_project_scene := preload("res://src/menu/gui/gui_project.tscn")

@onready var buttons_container := get_node(BUTTONS)
@onready var new_button := get_node(BUTTONS + "NewButton")
@onready var my_projects_button := get_node(BUTTONS + "MyProjectsButton")

@onready var workspace_container := get_node(WORKSPACE)
@onready var new_container := get_node(WORKSPACE + "New")
@onready var my_projects_container := get_node(WORKSPACE + "MyProjects")


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


func _on_mechanic_gui_input(event):
	print("event2")
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_tree().change_scene_to_file("res://src/main/main.tscn")
