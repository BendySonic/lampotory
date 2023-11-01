extends CanvasLayer
# Class for Main/GUI

signal item_pressed(item_data: ItemResource)
signal item_released()
signal items_window_mouse_exited()
signal play_toggled(button_pressed: bool)
signal reload_pressed()

const GUI_PATH = "res://src/main/gui/"

const ITEMS_WINDOW = "ItemsWindow/"
const ITEMS = ITEMS_WINDOW + "VBoxContainer/Body/VBox/Margin/ItemsContainer"
const PROPERTIES_WINDOW = "PropertiesWindow/"
const PROPERTIES_VIEW = PROPERTIES_WINDOW + "VBoxContainer/Body/HBoxContainer/"
const PROPERTIES = (
		PROPERTIES_VIEW + "PanelContainer/PropertiesContainer"
)
const WORKSPACE_AREA = "HUD/Other/WorkspaceArea/"
const INFO = WORKSPACE_AREA + "VBoxContainer/InfoLabel"
const PLAYER = "HUD/MenuBar/Player/"
const PLAY = PLAYER + "Play/PlayButton"
const RELOAD = PLAYER + "Reload/ReloadButton"

# Scenes
@onready var item_scene := preload(GUI_PATH + "gui_item.tscn")
@onready var property_scene := preload(GUI_PATH + "gui_property.tscn")
@onready var cursor_scene := preload(GUI_PATH + "gui_cursor.tscn")

# Child nodes
@onready var items_window := get_node(ITEMS_WINDOW) as Control
@onready var items_container := get_node(ITEMS) as GridContainer
@onready var properties_window := get_node(PROPERTIES_WINDOW) as Control
@onready var properties_container := get_node(PROPERTIES) as VBoxContainer

@onready var info_label := get_node(INFO)

@onready var play_button := get_node(PLAY) as Button
@onready var reload_button := get_node(RELOAD) as Button

@onready var cursor_layer := get_node("CursorLayer")



# Input handle
# Items in items window for choose body to spawn
func _on_item_pressed(item_data: ItemResource):
	emit_signal("item_pressed", item_data)

func _on_item_released():
	emit_signal("item_released")

func _on_items_window_mouse_exited():
	var local_mouse_position = items_window.get_local_mouse_position()
	if not Rect2(Vector2(), items_window.size).has_point(local_mouse_position):
		emit_signal("items_window_mouse_exited")

# Laboratory play, pause, reload
func _on_play_toggled(button_pressed: bool):
	emit_signal("play_toggled", button_pressed)

func _on_reload_pressed():
	play_button.button_pressed = false
	emit_signal("reload_pressed")

func _physics_process(_delta):
	_update_item_window()

func _update_item_window():
	if items_container.size.x >= 180 and items_container.size.x < 280:
		items_container.columns = 2
	elif items_container.size.x >= 280:
		items_container.columns = 3


# Public functions
# Fill items window by items from "item_resources"
func create_items(item_resources: Array[ItemResource]):
	for item_data in item_resources:
		var new_item = item_scene.instantiate()
		new_item.init(item_data)
		new_item.connect("item_pressed", _on_item_pressed)
		new_item.connect("item_released", _on_item_released)
		items_container.add_child(new_item)

#func select_item(index: int):
#	deselect_items()
#	item_list_control.select(index)

#func deselect_items():
#	item_list_control.deselect_all()

#func is_item_selected(index: int):
#	item_list_control.is_selected(index)

func create_properties(body: BodyBase):
	delete_properties()
	properties_window.set_position(body.get_global_position() + Vector2(30, -75))
	show_properties_window()
	var body_properties = body.get_edit_properties()
	
	for body_property in body_properties:
		var value = body.get_property(body_property)
		
		var new_property = property_scene.instantiate()
		new_property.init(body, body_property, value)
		properties_container.add_child(new_property)

func delete_properties():
	hide_properties_window()
	for child in properties_container.get_children():
		child.queue_free()

func hide_properties_window():
	properties_window.set_visible(false)

func show_properties_window():
	properties_window.set_visible(true)

func create_cursor(item_data: ItemResource):
	delete_cursor()
	var cursor: GUICursor = cursor_scene.instantiate()
	cursor.init(item_data)
	cursor_layer.add_child(cursor)

func delete_cursor():
	for child in cursor_layer.get_children():
		cursor_layer.remove_child(child)
		child.queue_free()
