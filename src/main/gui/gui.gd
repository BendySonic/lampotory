extends CanvasLayer
# Class for Main/GUI


signal item_pressed(item_data: ItemResource)
signal item_released()
signal items_window_mouse_exited()
signal play_toggled(button_pressed: bool)
signal reload_pressed()

signal copy_pressed()
signal cut_pressed()
signal paste_pressed()
signal delete_pressed()

const GUI_PATH = "res://src/main/gui/"

const ITEMS_WINDOW = "ItemsWindow/"
const ITEMS_BOX = ITEMS_WINDOW + "ItemsWindowBox/Body/BodyBox/Items/ItemsBox"
const PROPERTIES_WINDOW = "PropertiesWindow/"
const PROPERTIES_BOX = PROPERTIES_WINDOW + "Body/VBoxContainer"
const ACTIONS_WINDOW = "ActionsWindow/"
const ACTIONS_BOX = ACTIONS_WINDOW + "HBoxContainer/"
const PLAYER_WINDOW = "PlayerWindow/"
const PLAY_BUTTON = PLAYER_WINDOW + "Player/Play/PlayButton"
const RELOAD_BUTTON = PLAYER_WINDOW + "Player/Reload/ReloadButton"
const COPY_BUTTON = ACTIONS_BOX + "MarginContainer/CopyButton"
const CUT_BUTTON = ACTIONS_BOX + "MarginContainer2/CutButton"
const PASTE_BUTTON = ACTIONS_BOX + "MarginContainer3/PasteButton"
const DELETE_BUTTON = ACTIONS_BOX + "MarginContainer4/DeleteButton"

# Children
@onready var items_window := get_node(ITEMS_WINDOW) as Control
@onready var items_box := get_node(ITEMS_BOX) as GridContainer

@onready var properties_window := get_node(PROPERTIES_WINDOW) as Control
@onready var properties_box := get_node(PROPERTIES_BOX) as VBoxContainer

@onready var actions_window := get_node(ACTIONS_WINDOW) as Control
@onready var actions_box := get_node(ACTIONS_BOX) as VBoxContainer

@onready var play_button := get_node(PLAY_BUTTON) as Button
@onready var reload_button := get_node(RELOAD_BUTTON) as Button

@onready var copy_button := get_node(COPY_BUTTON) as TextureButton
@onready var cut_button := get_node(CUT_BUTTON) as TextureButton
@onready var paste_button := get_node(PASTE_BUTTON) as TextureButton
@onready var delete_button := get_node(DELETE_BUTTON) as TextureButton

# Resources
@onready var item_scene := preload(GUI_PATH + "gui_item.tscn")
@onready var property_scene := preload(GUI_PATH + "gui_property.tscn")
@onready var cursor_scene := preload(GUI_PATH + "gui_cursor.tscn")


#region Input
func _on_item_pressed(item_data: ItemResource):
	emit_signal("item_pressed", item_data)

func _on_item_released():
	emit_signal("item_released")

func _on_items_window_mouse_exited():
	var local_mouse_position = items_window.get_local_mouse_position()
	if not Rect2(Vector2(), items_window.size).has_point(local_mouse_position):
		emit_signal("items_window_mouse_exited")

func _on_play_toggled(button_pressed: bool):
	emit_signal("play_toggled", button_pressed)

func _on_reload_pressed():
	play_button.button_pressed = false
	emit_signal("reload_pressed")
#endregion

#region ItemsWindow
func create_items(item_resources: Array[ItemResource]):
	for item_data in item_resources:
		var new_item = item_scene.instantiate()
		new_item.init(item_data)
		new_item.connect("item_pressed", _on_item_pressed)
		new_item.connect("item_released", _on_item_released)
		items_box.add_child(new_item)
#endregion


#region Select
func clear_select():
	delete_actions()
	delete_properties()

func create_actions(cursor: GUICursor):
	actions_window.set_global_position(cursor.get_screen_transform().origin)
	copy_button.set_disabled(true)
	copy_button.modulate = Color(0.812, 0.812, 0.812)
	cut_button.set_disabled(true)
	cut_button.modulate = Color(0.812, 0.812, 0.812)
	delete_button.set_disabled(true)
	delete_button.modulate = Color(0.812, 0.812, 0.812)
	show_actions_window()

func create_actions_with_body(body: NormalBody):
	actions_window.set_global_position(body.get_screen_transform().origin)
	copy_button.set_disabled(false)
	copy_button.modulate = Color(1, 1, 1)
	cut_button.set_disabled(false)
	cut_button.modulate = Color(1, 1, 1)
	delete_button.set_disabled(false)
	delete_button.modulate = Color(1, 1, 1)
	show_actions_window()

func delete_actions():
	hide_actions_window()

func create_properties(body: NormalBody):
	delete_properties()
	properties_window.set_position(actions_window.get_position() + Vector2(0, 50))
	show_properties_window()
	var body_properties = body.get_edit_properties()
	
	for body_property in body_properties:
		var value = body.get_property(body_property)
		
		var new_property = property_scene.instantiate()
		new_property.init(body, body_property, value)
		properties_box.add_child(new_property)

func delete_properties():
	hide_properties_window()
	for child in properties_box.get_children():
		child.queue_free()

func hide_actions_window():
	actions_window.set_visible(false)

func show_actions_window():
	actions_window.set_visible(true)

func hide_properties_window():
	properties_window.set_visible(false)

func show_properties_window():
	properties_window.set_visible(true)


func _on_copy_button_down():
	copy_button.modulate = Color(0.812, 0.812, 0.812)

func _on_cut_button_down():
	cut_button.modulate = Color(0.812, 0.812, 0.812)

func _on_paste_button_down():
	paste_button.modulate = Color(0.812, 0.812, 0.812)

func _on_delete_button_down():
	delete_button.modulate = Color(0.812, 0.812, 0.812)


func _on_copy_button_up():
	copy_button.modulate = Color(1, 1, 1)
	emit_signal("copy_pressed")

func _on_cut_button_up():
	cut_button.modulate = Color(1, 1, 1)
	emit_signal("cut_pressed")

func _on_paste_button_up():
	paste_button.modulate = Color(1, 1, 1)
	emit_signal("paste_pressed")

func _on_delete_button_up():
	delete_button.modulate = Color(1, 1, 1)
	emit_signal("delete_pressed")
#endregion


#region Cursor
#func create_cursor(item_data: ItemResource):
	#delete_cursor()
	#var cursor: GUICursor = cursor_scene.instantiate()
	#cursor.init(item_data)
	#cursor_layer.add_child(cursor)

#func delete_cursor():
	#for child in cursor_layer.get_children():
		#cursor_layer.remove_child(child)
		#child.queue_free()
#endregion
