class_name GUI
extends CanvasLayer
# Class for GUI

# -----------------------------------------------------------------------------
const MAIN_GUI = "res://src/main/gui/"
const PLAYER = "HUD/MenuBar/Player/"
const WORKSPACE_AREA = "HUD/Other/WorkspaceArea/"
const INFO = WORKSPACE_AREA + "VBoxContainer/Info"
const ITEM_LIST = "ObjectsWindow/VBoxContainer/Body/VBox/Margin/ItemList"
const PROPERTIES_CONTROL = "PropertiesWindow/VBoxContainer/Margin/Properties"
# World
var play_world: Callable
var reload_world: Callable
var save_world: Callable
var load_world: Callable

var create_body: Callable
var deselect_bodies: Callable
var set_selected_item_data: Callable
var get_selected_item_data: Callable
var get_body: Callable
var get_bodies: Callable
var get_bodies_count: Callable
var get_selected_body: Callable
var has_selected_item_data: Callable
var has_selected_body: Callable
# Main
var get_mode_data: Callable

@onready var grid_widget_scene := preload(MAIN_GUI + "gui_grid_widget.tscn")
@onready var cursor_widget_scene := preload(MAIN_GUI + "gui_cursor_widget.tscn")
@onready var property_scene := preload(MAIN_GUI + "gui_property.tscn")

@onready var item_list:ItemList = get_node(ITEM_LIST)
@onready var properties_control := get_node(PROPERTIES_CONTROL)
@onready var realtime_properties_control := get_node(INFO)
@onready var workspace_area := get_node(WORKSPACE_AREA)
@onready var play_button := get_node(PLAYER + "Play/TextureButton")
@onready var reload_button := get_node(PLAYER + "Reload/TextureButton")

@onready var select := get_node("SelectedObject")

# -----------------------------------------------------------------------------
# TODO - Develop save/load system by window
func _ready():
	_create_items()

func _physics_process(_delta):
	_update_item_list()
	_update_realtime_properties()

# TODO - Fix body spawn (Check for another bodies)
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if has_selected_item_data.call():
				create_body.call(get_selected_item_data.call())

func _on_item_list_item_clicked(index: int,
		at_position: Vector2, mouse_button_index: int):
	var body_data: BodyResource = item_list.get_item_metadata(index)
	body_data.item_selected = not body_data.item_selected
	if body_data.item_selected:
		# Clear select
		for i in range(0, item_list.get_item_count()):
			if not index == i:
				item_list.get_item_metadata(i).item_selected = false
		for child in select.get_children():
			select.remove_child(child)
			child.queue_free()
		# Create new cursor
		var cursor_widget = cursor_widget_scene.instantiate()
		select.add_child(cursor_widget)
		cursor_widget.construct(body_data)
		# Set new selected data
		set_selected_item_data.call(body_data)
	else:
		# Delete cursor
		for child in select.get_children():
			select.remove_child(child)
			child.queue_free()
		# Remove selected data
		set_selected_item_data.call(null)

# Deselect body when 
func _on_workspace_area_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			for body in get_bodies.call():
				if body.is_mouse_inside():
					return 0
			deselect_bodies.call()
			delete_properties()
			_reload_realtime_properties()

func _on_play_toggled(button_pressed: bool):
	play_world.call(button_pressed)

func _on_reload_pressed():
	play_button.button_pressed = false
	reload_world.call()


# Grid widget is element of body list in UI
# Every mode show own grid widgets
func _create_items():
	for body_name in get_mode_data.call().body_names:
		var body_data = get_mode_data.call().body_resources[body_name]
		var item_name = body_data.item_name
		var body_icon = body_data.body_icon
		var item_tooltip = body_data.item_tooltip
		var index = item_list.add_item(item_name, body_icon, true)
		item_list.set_item_metadata(index, body_data)
		item_list.set_item_icon_modulate(index, Color(0.278, 0.6, 1))
		item_list.set_item_tooltip(index, item_tooltip)

func _update_item_list():
	if item_list.size.x >= 180 and item_list.size.x < 280:
		item_list.max_columns = 2
	elif item_list.size.x >= 280:
		item_list.max_columns = 3

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

func _reload_realtime_properties():
	realtime_properties_control.text = ("Скорость: 0" +
						"\nУскорение: 0\nПройденный путь: 0")


func create_properties(body_properties: Dictionary):
	var local_ru = get_mode_data.call().local_ru
	for body_property in body_properties:
		var property_instance = property_scene.instantiate()
		properties_control.add_child(property_instance)
		property_instance.construct(body_properties, body_property, local_ru)

func delete_properties():
	for child in properties_control.get_children():
		child.queue_free()
