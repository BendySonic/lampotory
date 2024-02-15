extends Node

var project_data: Dictionary = {
	"project_name": "",
	"project_theme": "",
	"project_mode": "",
	"is_saved": false
}

var cursor: GUICursor

func is_current_project_saved():
	return project_data["is_saved"]

func get_current_project_name():
	return project_data["project_name"]

func get_current_project_mode():
	return project_data["project_mode"]
