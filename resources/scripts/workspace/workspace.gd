class_name Workspace
extends Node2D

# -----------------------------------------------------------------------------
const MODE_RESOURCE_PATH = "res://resources/scenes/workspace/mode_resources/"
const MODES = ["mechanic_1d", "mechanic_2d"]

var _mode: int = 0
var _mode_data: ModeResource
var _body_data: BodyResource
var _body_count: int = 0
var _is_playing: bool = false

@onready var ui = $LayerUI/UI
@onready var layer_ui = $LayerUI
@onready var layer_selected = $LayerSelected
@onready var layer_workspace = $LayerWorkspace

# -----------------------------------------------------------------------------
func _ready():
	# Set workspace mode (mode_data).
	_mode_data = load(MODE_RESOURCE_PATH + MODES[_mode] + ".tres")

	# Load body scenes (mode_data).
	for body_name in _mode_data.body_names:
		_mode_data.body_scenes[body_name] = (
			load(_mode_data.body_path + body_name + ".tscn")
		)
	
	# Load body resources (mode_data).
	for body_name in _mode_data.body_names:
		_mode_data.resources[body_name] = (
			load(_mode_data.body_resource_path + body_name + ".tres")
		)
	
	# Set workspace scenes.
	for widget_name in _mode_data.body_names:
		var widget = ui.grid_widget.instantiate()
		ui.grid.add_child(widget)
		widget.construct(_mode_data.resources[widget_name])
	
	# Connect signals.
	LampSignalManager.widget_input.connect(_on_grid_widget_input)
	LampSignalManager.body_input.connect(_on_body_input)
	LampSignalManager.play_pressed.connect(_on_play_pressed)
	LampSignalManager.reload_pressed.connect(_on_reload_pressed)


func _on_grid_widget_input(event:InputEventMouse, grid_widget:UIGridWidget):
	if event is InputEventMouseButton:
		if event.is_pressed():
			_body_data = grid_widget.data.duplicate()
			
			# Cursor create.
			var cursor_widget = ui.cursor_widget.instantiate()
			layer_selected.add_child(cursor_widget)
			cursor_widget.construct(_body_data)
			
		
		elif not event.is_pressed():
			_body_count += 1
			_body_data.id = _body_count
			
			# Body create.
			var body = (
				_mode_data.body_scenes[_body_data.body_name].instantiate()
			)
			body.position = Vector2(get_global_mouse_position().x, 0)
			body.construct(_body_data, _mode_data)
			layer_workspace.add_child(body)
			
			# Cursor delete.
			var cursor_widget = layer_selected.get_child(0)
			layer_selected.remove_child(cursor_widget)
			cursor_widget.queue_free()


## Show body properties on click
func _on_body_input(properties:Dictionary):
	# Delete all properties.
	if bool(ui.properties.get_child_count()):
		for child in ui.properties.get_children():
			child.queue_free()
	# Create all properties.
	for property in properties:
		# Check for property template in _mode_data.
		var base_property
		for dictionary in _mode_data.properties:
			if dictionary["id"] == property:
				base_property = dictionary
		if base_property == null:
			continue
		
		var property_scene = ui.property.instantiate()
		ui.properties.add_child(property_scene)
		property_scene.construct(base_property, properties, property)


func _on_play_pressed():
	_is_playing = !_is_playing
	for body in layer_workspace.get_children():
		if _is_playing:
			body.play()
		else:
			body.pause()


func _on_reload_pressed():
	_is_playing = false
	for body in layer_workspace.get_children():
		body.reload()
