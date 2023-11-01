extends Node2D
# Class for Main/Node2D

signal void_pressed()
signal body_held(body: BodyBase)
signal body_unheld(body: BodyBase)
signal body_selected(body: BodyBase)
signal body_deselected(body: BodyBase)

enum States {PLAY, PAUSE}

const PROJECT_PATH := "res://data/"

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
var held_body: Variant:
	get: return held_body

@onready var bodies_node := get_node("Bodies") as Node
@onready var foreground := get_node("Enviroment/Foreground/Mechanic") as Node
@onready var camera := get_node("Camera/Camera2D") as Camera2D



# TODO - Develop save/load system by window
# TODO - Fix body spawn (Check for another bodies)
# Private 
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index ==1 and event.is_pressed(): 
			if not is_any_body_mouse_inside():
				emit_signal("void_pressed")

func _on_body_held(body: BodyBase):
	unhold_held_body()
	held_body = body
	emit_signal("body_held", body)

func _on_body_unheld(body: BodyBase):
	held_body = null
	emit_signal("body_unheld", body)

func _on_body_selected(body: BodyBase):
	deselect_selected_body()
	selected_body = body
	emit_signal("body_selected", body)

func _on_body_deselected(body: BodyBase):
	selected_body = null
	emit_signal("body_deselected", body)


# Public methods
func save_world(file_path: String):
	var bodies_properties: Array[Dictionary]
	for body in get_children():
		bodies_properties.push_back(body.get_properties())
	LampFileManager.save_file(PROJECT_PATH + file_path, bodies_properties)

func load_world(file_path: String):
	return LampFileManager.load_file(PROJECT_PATH + file_path)

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

func create_body(item_data: ItemResource) -> Node:
	var body = item_data.item_scene.instantiate()
	body.init(item_data, get_global_mouse_position())
	body.connect("body_held", _on_body_held)
	body.connect("body_unheld", _on_body_unheld)
	body.connect("body_selected", _on_body_selected)
	body.connect("body_deselected", _on_body_deselected)
	bodies_node.add_child(body)
	
	return body

func delete_body(body_id: String):
	for body in get_bodies():
		if body.get_id() == body_id:
			body.queue_free()

func unhold_held_body():
	if not held_body == null:
		held_body.unhold_body()
		held_body = null

func deselect_selected_body():
	if not selected_body == null:
		selected_body.deselect_body()
		selected_body = null

func get_body(body_id: String) -> BodyBase:
	for body in get_bodies():
		if body.get_id() == body_id:
			return body
	return null

func get_bodies() -> Array[Node]:
	return get_node("Bodies").get_children()

func is_any_body_mouse_inside() -> bool:
	for body in get_bodies():
		if body.is_mouse_inside() and not body.is_body_held():
			return true
	return false

func is_foreground_mouse_inside() -> bool:
	return foreground.is_mouse_inside()
