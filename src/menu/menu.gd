extends Control
# Class for menu


const BUTTONS = "Panel/Panel/Menu/Menu/Menu/Buttons/"
const WORKSPACE = "Panel/Panel/Workspace/"

var change_scene_to: Callable

@onready var gui_project_scene := preload("res://src/menu/gui/gui_project.tscn")

@onready var buttons_container := get_node(BUTTONS)
@onready var start_button := get_node(BUTTONS + "Start")
@onready var projects_button := get_node(BUTTONS + "Projects")
@onready var sandbox_button := get_node(BUTTONS + "Sanbox")

@onready var workspace_container := get_node(WORKSPACE)
@onready var start_container := get_node(WORKSPACE + "Start")
@onready var projects_container := get_node(WORKSPACE + "Projects")


# TODO - Develop create project window
func init(call_arg: Callable, arg: Variant):
	self.change_scene_to = call_arg

func _on_create_project_button_down():
	change_scene_to.call(
			preload("res://src/main/main.tscn"),
			preload("res://src/main/modes/mechanic.tres")
	)

func _on_start_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		start_container.set_visible(true)

func _on_projects_toggled(button_pressed: bool):
	if button_pressed:
		_set_invisible_containers()
		projects_container.set_visible(true)

func _set_invisible_containers():
	for container in workspace_container.get_children():
		container.set_visible(false)
