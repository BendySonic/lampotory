class_name Workspace extends Node2D


const MODE_RESOURCE_PATH = "res://resources/scenes/workspace/mode_resources/"
const MODES = ["mechanic_1d", "mechanic_2d"]

var mode:int = 0
var mode_data:ModeResource
var body_data:BodyResource
var body_count:int = 0
var is_playing:bool = false

@onready var ui = get_node("LayerUI/UI")
@onready var layer_ui = $LayerUI
@onready var layer_selected = $LayerSelected
@onready var layer_workspace = $LayerWorkspace


func _ready():
	# Set workspace mode (mode_data).
	mode_data = load(MODE_RESOURCE_PATH + MODES[mode] + ".tres")

	# Load body scenes (mode_data).
	for body_name in mode_data.body_names:
		mode_data.body_scenes[body_name] = (
			load(mode_data.body_path + body_name + ".tscn")
		)
	
	# Load body resources (mode_data).
	for body_name in mode_data.body_names:
		mode_data.resources[body_name] = (
			load(mode_data.body_resource_path + body_name + ".tres")
		)
	
	# Set workspace scenes.
	for widget_name in mode_data.body_names:
		var widget = ui.grid_widget.instantiate()
		ui.grid.add_child(widget)
		widget.construct(mode_data.resources[widget_name])
	
	# Connect signals.
	LampSignalManager.widget_input.connect(on_grid_widget_gui_input)
	LampSignalManager.body_input.connect(on_body_gui_input)
	LampSignalManager.play.connect(on_play)
	LampSignalManager.reload.connect(on_reload)


func on_grid_widget_gui_input(event:InputEventMouse, grid_widget:UIGridWidget):
	if event is InputEventMouseButton:
		if event.is_pressed():
			body_data = grid_widget.data.duplicate()
			
			# Cursor create.
			var cursor_widget = ui.cursor_widget.instantiate()
			layer_selected.add_child(cursor_widget)
			cursor_widget.construct(body_data)
			
		
		elif not event.is_pressed():
			body_count += 1
			body_data.id = body_count
			
			# Body create.
			var body = mode_data.body_scenes[body_data.body_name].instantiate()
			body.position = Vector2(get_global_mouse_position().x, 0)
			body.construct(body_data, mode_data)
			layer_workspace.add_child(body)
			
			# Cursor delete.
			var cursor_widget = layer_selected.get_child(0)
			layer_selected.remove_child(cursor_widget)
			cursor_widget.queue_free()


## Show body properties on click
func on_body_gui_input(properties:Dictionary):
	# Delete all properties.
	if bool(ui.properties.get_child_count()):
		for child in ui.properties.get_children():
			child.queue_free()
	# Create all properties.
	for property in properties:
		# Check for property template in mode_data.
		var base_property = null
		for dictionary in mode_data.properties:
			if dictionary["id"] == property:
				base_property = dictionary
		if base_property == null:
			continue
		
		var property_scene = ui.property.instantiate()
		ui.properties.add_child(property_scene)
		property_scene.construct(base_property, properties, property, mode_data)


func on_play():
	is_playing = !is_playing
	for body in layer_workspace.get_children():
		if is_playing:
			body.play()
		else:
			body.pause()


func on_reload():
	is_playing = false
	for body in layer_workspace.get_children():
		body.reload()
