extends Control
# Class for menu


@onready var gui_project_scene = preload("res://src/menu/gui/gui_project.tscn")

@onready var start = get_node("Panel/Panel/Menu/Menu/Menu/Start")
@onready var projects = get_node("Panel/Panel/Menu/Menu/Menu/Projects")
@onready var sandbox = get_node("Panel/Panel/Menu/Menu/Menu/Sanbox")

@onready var start_container = get_node("Panel/Panel/Workspace/Start")
@onready var projects_container = get_node("Panel/Panel/Workspace/Projects")


func _ready():
	pass


func _on_create_project_pressed():
	pass


func _on_start_toggled(button_pressed: bool):
	if button_pressed:
		start_container.set_visible(true)
		_set_pressed_buttons(false, [projects, sandbox])
		_set_visible_container(false, [projects_container])

func _on_projects_toggled(button_pressed: bool):
	if button_pressed:
		projects_container.set_visible(true)
		_set_pressed_buttons(false, [start, sandbox])
		_set_visible_container(false, [start_container])


func _set_pressed_buttons(pressed: bool, buttons: Array[BaseButton]):
	for button in buttons:
		button.set_pressed(pressed)

func _set_visible_container(visible: bool, containers: Array[Container]):
	for container in containers:
		container.set_visible(visible)
