class_name workspace extends Node2D

const MECH_BODY_PATH = ["square_body", "ball_body"]
const MENU_GRID_PATH = "VBox_1/HBox_2/menu/margin/VBox_1/MarginContainer/Grid"
const MENU_PATH = "VBox_1/HBox_2/menu"

var loads:Dictionary
var ui:Node
var grid:Node

@onready var layer_ui:CanvasLayer = $LayerUI
@onready var layer_choose:CanvasLayer = $LayerChoose


func _input(event):
	if event is InputEventMouseButton:
		#gridObject click
		for grid_object in grid.get_children():
			if grid_object.is_mouse_inside() and event.is_pressed():
				var object_cursor = loads["menu_object"].instantiate()
				object_cursor.construct(grid_object.get_info())
				object_cursor.set_follow_mouse()
				
				object_cursor.add_to_group("object_cursor")
				layer_choose.add_child(object_cursor)
		
		#objectCurso
		for object_cursor in layer_choose.get_children():
			if object_cursor.is_in_group("object_cursor"):
				if !event.is_pressed():
					object_cursor.remove_from_group("object_cursor")
					layer_choose.remove_child(object_cursor)


func _ready():
	load_resources()
	load_scenes()


func load_scenes():
	#ui
	ui = loads["ui"].instantiate()
	layer_ui.add_child(ui)
	
	#grid
	grid = ui.get_node(MENU_GRID_PATH)
	
	#menu_objects
	for object_name in MECH_BODY_PATH:
		var object = loads["menu_object"].instantiate()
		object.construct(object_name)
		grid.add_child(object)


func load_resources():
	loads = {
		"ui": preload("res://resources/gameScenes/workspace_ui.tscn") ,
		"menu_object": preload("res://resources/gameScenes/menu_object.tscn"),
	}
