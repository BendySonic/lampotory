class_name workspace extends Node2D

const MECH_OBJ_PATH = ["square", "sugaryspire"]
const OBJ_GRID_PATH = "VBox_1/HBox_2/menu/margin/VBox_1/MarginContainer/Grid"
const OBJ_MENU_PATH = "VBox_1/HBox_2/menu"

@onready var canvasLayer = $canvasLayer_UI
@onready var canvasLayer_choose = $canvasLayer_choose
var load:Node
var ui_instance:Node

func _input(event):
	if event is InputEventMouseButton:
		for object in ui_instance.get_node(OBJ_GRID_PATH).get_children():
			if object.is_mouse_inside() and event.is_pressed():
				var object_cursor = workspace_scenes["menu_object"].instantiate()
				object_cursor.construct(object.get_info())
				object_cursor.set_follow_mouse()
				
				canvasLayer_choose.add_child(object_cursor)
				object_cursor.add_to_group("objectCursor")
		
		for object_cursor in canvasLayer_choose.get_children():
			if object_cursor.is_in_group("objectCursor"):
				if !event.is_pressed():
					object_cursor.remove_from_group("objectCursor")
					canvasLayer_choose.remove_child(object_cursor)
					
	#obj.position.x = get_global_mouse_position().x - int(get_global_mouse_position().x) % 32
	#obj.position.y = get_global_mouse_position().y - int(get_global_mouse_position().y) % 32

func _ready():
	workspace_scenes = load.workspace_scenes()
	
	ui_instance = workspace_scenes["ui"].instantiate()
	canvasLayer.add_child(ui_instance)
	
	for argName in MECH_OBJ_PATH:
		var menu_object = workspace_scenes["menu_object"].instantiate()
		menu_object.construct(argName)
		ui_instance.get_node(OBJ_GRID_PATH).add_child(menu_object)

class loadManager extends Node:
	func objects():
		pass
	
func workspace_scenes():
	var loads = {
		"ui": load("res://resources/gameScenes/workspaceUI.tscn") ,
		"menu_object": load("res://resources/gameScenes/menuObject.tscn")
	}
	
	return loads
