class_name GUIProject
extends MarginContainer

var project_data: Dictionary

@onready var name_label: Label = get_node(
		"PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name"
)
@onready var path_label: Label = get_node(
		"PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Path"
)

func _ready():
	name_label.text = project_data["project_name"]
	path_label.text = project_data["project_path"]


func _on_edit_button_pressed():
	Global.project_data = project_data
	Global.project_data["project_mode"] = "mechanic"
	get_tree().change_scene_to_file("res://src/main/loading/loading.tscn")
