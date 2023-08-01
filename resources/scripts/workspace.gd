#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#workspace.gd
#script for laboratory workspace
#################################
class_name workspace extends Node2D

const MECHANIC_BODY_PATH = ["square_body", "ball_body"]
const GRID_PATH = "VBox/HBox2/Panel/Margin/VBox/Margin/Grid"
const PANEL_PATH = "VBox/HBox2/Panel"

var loads:Dictionary
var ui:Node
var grid:Node
var panel:Node

@onready var layer_ui:CanvasLayer = $LayerUI
@onready var layer_choose:CanvasLayer = $LayerChoose

#godot functions
func _input(event):
	if event is InputEventMouseButton:
		#grid_widget click
		for grid_widget in grid.get_children():
			if grid_widget.is_mouse_inside() and event.is_pressed():
				var widget_cursor = loads["grid_widget"].instantiate()
				widget_cursor.construct(grid_widget.get_info())
				widget_cursor.set_follow_mouse()
				layer_choose.add_child(widget_cursor)
				
		#widget_cursor release
		if !event.is_pressed() and bool(layer_choose.get_child_count()):
			var widget_cursor = layer_choose.get_child(0)
			layer_choose.remove_child(widget_cursor)
			widget_cursor.queue_free()
			
			
			


func _ready():
	load_resources()
	load_scenes()


func load_scenes():
	#ui
	ui = loads["ui"].instantiate()
	layer_ui.add_child(ui)
	
	#grid
	grid = ui.get_node(GRID_PATH)
	
	#panel
	panel = ui.get_node(PANEL_PATH)
	
	#grid_widgets
	for widget_name in MECHANIC_BODY_PATH:
		var widget = loads["grid_widget"].instantiate()
		widget.construct(widget_name)
		grid.add_child(widget)


func load_resources():
	loads = {
		"ui": preload("res://resources/scenes/workspace_ui.tscn") ,
		"grid_widget": preload("res://resources/scenes/grid_widget.tscn"),
		
		"square_body": preload("res://resources/scenes/bodies/square_body.tscn"),
	}
