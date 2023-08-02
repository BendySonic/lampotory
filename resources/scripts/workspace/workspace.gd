#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#workspace.gd
#script for laboratory workspace
#################################
class_name workspace extends Node2D

#private variables
const SCENES_PATH = "res://resources/scenes/workspace/"
const RESOURCES_PATH = "res://resources/godot_resources/body_resources/"
const BODIES_PATH = "res://resources/scenes/bodies/"

const SCENES = ["ui", "grid_widget", "widget_cursor"]
const BODIES = ["square_body"]

const GRID_PATH = "VBox/HBox2/Panel/Margin/VBox/Margin/Grid"
const PANEL_PATH = "VBox/HBox2/Panel"

var scenes:Dictionary
var resources:Dictionary
var bodies:Dictionary
var choosen_res:body_resource

var ui:Node
var grid:Node
var panel:Node

@onready var layer_ui:CanvasLayer = $LayerUI
@onready var layer_selected:CanvasLayer = $LayerSelected
@onready var layer_workspace:Node2D = $LayerWorkspace

#private functions
func _input(event):	
	if event is InputEventMouseButton:
		#grid_widget click
		for grid_widget in grid.get_children():
			if grid_widget.is_mouse_inside() and event.is_pressed():
				choosen_res = resources[grid_widget.get_widget_name()]
				
				var widget_cursor = scenes["widget_cursor"].instantiate()
				widget_cursor.construct(choosen_res)
				layer_selected.add_child(widget_cursor)
				
		#widget_cursor release / create body
		if not event.is_pressed() and bool(layer_selected.get_child_count()):
			var body = bodies["square_body"].instantiate()
			body.position = get_global_mouse_position()
			layer_workspace.add_child(body)
			var widget_cursor = layer_selected.get_child(0)
			layer_selected.remove_child(widget_cursor)
			widget_cursor.queue_free()
			


func _ready():
	load_scenes()
	load_body_resources()
	load_body_scene()
	set_scenes()


func set_scenes():
	#ui
	ui = scenes["ui"].instantiate()
	layer_ui.add_child(ui)
	
	#grid and panel
	grid = ui.get_node(GRID_PATH)
	panel = ui.get_node(PANEL_PATH)
	
	#grid_widgets
	for widget_name in BODIES:
		var widget = scenes["grid_widget"].instantiate()
		widget.construct(resources[widget_name])
		grid.add_child(widget)


func load_scenes():
	for scene_name in SCENES:
		scenes[scene_name] = load(SCENES_PATH + scene_name + ".tscn")


func load_body_resources():
	for body_name in BODIES:
		resources[body_name] = load(RESOURCES_PATH + body_name + ".tres")

func load_body_scene():
	for body_name in BODIES:
		bodies[body_name] = load(BODIES_PATH + body_name + ".tscn")
