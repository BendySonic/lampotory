extends Control
# Class for menu

const MENU = "Panel/Panel/Menu/Menu/Menu/"
const WORKSPACE = "Panel/Panel/Workspace/"

@onready var gui_project_scene := preload("res://src/menu/gui/gui_project.tscn")
@onready var main_scene := preload("res://src/main/main.tscn")

@onready var start := get_node(MENU + "Start")
@onready var projects := get_node(MENU + "Projects")
@onready var sandbox := get_node(MENU + "Sanbox")

@onready var start_container := get_node(WORKSPACE + "Start")
@onready var projects_container := get_node(WORKSPACE + "Projects")


func _ready():
	pass

# TODO - Develop create project window
func _on_create_project_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_start_toggled(button_pressed: bool):
	if button_pressed:
		start_container.set_visible(true)
		_set_pressed_buttons(false, [projects, sandbox])
		_set_visible_containers(false, [projects_container])

func _on_projects_toggled(button_pressed: bool):
	if button_pressed:
		projects_container.set_visible(true)
		_set_pressed_buttons(false, [start, sandbox])
		_set_visible_containers(false, [start_container])


func _set_pressed_buttons(pressed: bool, buttons: Array[BaseButton]):
	for button in buttons:
		button.set_pressed(pressed)

func _set_visible_containers(visible: bool, containers: Array[Container]):
	for container in containers:
		container.set_visible(visible)
