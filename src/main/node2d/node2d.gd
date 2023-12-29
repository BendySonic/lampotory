extends Node2D
# Class for Main/Node2D

signal void_pressed()
signal body_held(body: NormalBody)
signal body_unheld(body: NormalBody)
signal body_selected(body: NormalBody)
signal body_deselected(body: NormalBody)

enum States {PLAY, PAUSE}

const PROJECT_PATH := "res://saves/"

var state: States = States.PLAY:
	get: return state
var speed: float = 1:
	get: return speed
# Data container for selected body
var selected_body: Variant:
	get: return selected_body
# Data containers durning body spawn
var selected_item_data: Variant:
	get: return selected_item_data

@onready var bodies_node := get_node("Bodies") as Node
@onready var foreground := get_node("Enviroment/Lab/Mechanic") as Node
@onready var camera := get_node("Camera/Camera2D") as Camera2D
@onready var cursor := get_node("GUICursor") as GUICursor

func _input(event):
	print("Mouse: ", get_global_mouse_position())

#region Input
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed(): 
			if not is_any_body_mouse_inside():
				emit_signal("void_pressed")
#endregion


#region Body input
func _on_body_held(body: NormalBody):
	emit_signal("body_held", body)

func _on_body_unheld(body: NormalBody):
	emit_signal("body_unheld", body)

func _on_body_selected(body: NormalBody):
	clear_select()
	selected_body = body
	emit_signal("body_selected", body)

func _on_body_deselected(body: NormalBody):
	selected_body = null
	emit_signal("body_deselected", body)
#endregion


#region Saver
# TODO - Develop save/load system by window
func save_world(file_path: String):
	var bodies_properties: Array[Dictionary]
	for body in get_children():
		bodies_properties.push_back(body.get_properties())
	LampFileManager.save_file(PROJECT_PATH + file_path, bodies_properties)

func load_world(file_path: String):
	return LampFileManager.load_file(PROJECT_PATH + file_path)
#endregion


#region Player
func play(button_pressed: bool):
	state = States.PLAY if button_pressed else States.PAUSE
	for body in get_bodies():
		if button_pressed:
			body.play()
		else:
			body.pause()

func reload():
	state = States.PLAY
	for body in get_bodies():
		body.reload()
#endregion


#region ItemsWindow
func item_pressed(item_data: ItemResource):
	selected_item_data = item_data

func item_released():
	selected_item_data = null
#endregion


#region Bodies
# TODO - Fix body spawn (Check for another bodies)
func create_body():
	if not selected_item_data == null:
		var item_data = selected_item_data
		var body = item_data.item_scene.instantiate()
		body.connect("body_held", _on_body_held)
		body.connect("body_unheld", _on_body_unheld)
		body.connect("body_selected", _on_body_selected)
		body.connect("body_deselected", _on_body_deselected)
		body.init(item_data, get_global_mouse_position(), cursor)
		bodies_node.add_child(body)
		
		selected_item_data = null

func delete_body(body_id: String):
	for body in get_bodies():
		if body.get_id() == body_id:
			body.queue_free()

func clear_select():
	if not selected_body == null:
		selected_body.deselect_body()
		selected_body = null

func get_body(body_id: String) -> NormalBody:
	for body in get_bodies():
		if body.get_id() == body_id:
			return body
	return null

func get_bodies() -> Array[Node]:
	return get_node("Bodies").get_children()

func is_any_body_mouse_inside() -> bool:
	for body in get_bodies():
		if body.is_mouse_inside() and not body.is_held():
			return true
	return false
#endregion


#region Foreground
func is_foreground_mouse_inside() -> bool:
	return foreground.is_mouse_inside()
#endregion
