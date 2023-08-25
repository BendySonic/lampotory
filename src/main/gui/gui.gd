extends CanvasLayer
# Class for GUI

# -----------------------------------------------------------------------------
# World
var play_world: Callable
var reload_world: Callable
var save_world: Callable
var load_world: Callable

var create_body: Callable
var deselect_bodies: Callable
var get_bodies: Callable
var get_bodies_count: Callable
var get_selected_body: Callable
var has_selected_body: Callable
# Main
var get_mode_data: Callable

@onready var grid_widget_scene := preload("res://src/main/gui/" +
		"gui_grid_widget.tscn")
@onready var cursor_widget_scene := preload("res://src/main/gui/" +
		"gui_cursor_widget.tscn")
@onready var property_scene := preload("res://src/main/gui/" +
		"gui_property.tscn")

@onready var grid_control := get_node("ObjectsWindow/VBoxContainer/" +
		"Body/VBox/Margin/Grid")
@onready var properties_control := get_node("PropertiesWindow/" +
		"VBoxContainer/Margin/Properties")
@onready var realtime_properties_control := get_node("HUD/Other/" +
		"WorkspaceArea/VBoxContainer/Info")
@onready var workspace_area := get_node("HUD/Other/WorkspaceArea")
@onready var play_button := get_node("HUD/MenuBar/Player/Play/" +
		"TextureButton")
@onready var reload_button := get_node("HUD/MenuBar/Player/Reload/" +
		"TextureButton")

@onready var select := get_node("SelectedObject")


# -----------------------------------------------------------------------------
func _ready():
	_create_grid_widgets()
	LampSignalManager.widget_input.connect(_on_grid_widget_input)

func _physics_process(_delta):
	_update_grid()
	_update_realtime_properties()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			unblock_workspace_area_input()
	else:
		if Input.is_action_just_pressed("load"):
			load_world.call("test.json")
		elif Input.is_action_just_pressed("save"):
			save_world.call("test.json")


# GRID_WIDGET is element of body list in UI
func _on_grid_widget_input(event: InputEventMouse, grid_widget: GUIGridWidget):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# Body data is data container for new body
			var body_data: BodyResource = grid_widget.data.duplicate()
			
			# Cursor create.
			var cursor_widget = cursor_widget_scene.instantiate()
			select.add_child(cursor_widget)
			cursor_widget.construct(body_data)
		
		elif not event.is_pressed():
			var cursor_widget = select.get_child(0)
			var body_data: BodyResource = cursor_widget.data
			
			# Cursor delete.
			select.remove_child(cursor_widget)
			cursor_widget.queue_free()
			
			# Body create.
			create_body.call(body_data)

func _on_workspace_area_gui_input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			deselect_bodies.call()
			delete_properties()
			realtime_properties_control.text = ("Скорость: 0" +
					"\nУскорение: 0\nПройденный путь: 0")

func _on_play_toggled(button_pressed: bool):
	play_world.call(button_pressed)

func _on_reload_pressed():
	play_button.button_pressed = false
	reload_world.call()


# Grid widget is element of body list in UI
# Every mode show own grid widgets
func _create_grid_widgets():
	for widget_name in get_mode_data.call().body_names:
		var grid_widget = grid_widget_scene.instantiate()
		grid_control.add_child(grid_widget)
		grid_widget.construct(get_mode_data.call().body_resources[widget_name])

func _update_grid():
	if grid_control.size.x >= 180 and grid_control.size.x < 280:
		grid_control.columns = 2
	elif grid_control.size.x >= 280:
		grid_control.columns = 3

func _update_realtime_properties():
	if has_selected_body.call():
		var body = get_selected_body.call()
		realtime_properties_control.text = (
				"Скорость: " + LampLib.trfr(str(
					body.get_realtime_property("speed")), 2)
				+ "\nУскорение: " + LampLib.trfr(str(
					body.get_realtime_property("acceleration")), 2)
				+ "\nПройденный путь: " + LampLib.trfr(str(
					body.get_realtime_property("path")), 2)
		)


func create_properties(body_properties: Dictionary):
	var local_ru = get_mode_data.call().local_ru
	for body_property in body_properties:
		var property_instance = property_scene.instantiate()
		properties_control.add_child(property_instance)
		property_instance.construct(body_properties, body_property, local_ru)

func delete_properties():
	for child in properties_control.get_children():
		child.queue_free()

func unblock_workspace_area_input():
	workspace_area.set_mouse_filter(1)

func block_workspace_area_input():
	workspace_area.set_mouse_filter(2)
