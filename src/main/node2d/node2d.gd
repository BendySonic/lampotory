extends Node2D
# Class for Main/Node2D

signal void_pressed(event)
signal body_held(body: NormalBody)
signal body_unheld(body: NormalBody)
signal body_selected(body: NormalBody)
signal body_deselected(body: NormalBody)

enum States {PLAY, PAUSE}

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

var buffer_body: Variant:
	get: return buffer_body

var is_camera_drag: bool
var releative_drag_position: Vector2

@onready var bodies_node := get_node("Bodies") as Node
@onready var lab := get_node("Enviroment/Lab/Mechanic") as Node
@onready var camera := get_node("Camera/Camera2D") as Camera2D
@onready var cursor := get_node("GUICursor") as GUICursor:
	get = get_cursor

#region Input
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed(): 
			if not is_any_body_mouse_inside():
				emit_signal("void_pressed", event)
#endregion

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 3:
			if event.is_pressed():
				is_camera_drag = true
				releative_drag_position = camera.to_local(cursor.global_position)
			elif event.is_released():
				is_camera_drag = false

func _process(delta):
	if is_camera_drag:
		camera.global_position += (- camera.to_local(cursor.global_position) +
				releative_drag_position)
		releative_drag_position += (camera.to_local(cursor.global_position) - 
				releative_drag_position)

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


#region ItemsWindow
func item_pressed(item_data: ItemResource):
	selected_item_data = item_data

func item_released():
	selected_item_data = null
#endregion


#region Saver
func first_project_load():
	bodies_node.project_data = Global.project_data

func save_project(name: String, theme: String):
	Global.project_data["project_name"] = name
	Global.project_data["project_theme"] = theme
	Global.project_data["is_saved"] = true
	bodies_node.project_data = Global.project_data.duplicate()
	LampFileManager.save_file(bodies_node, name)
	var project = LampFileManager.load_file(name)

func load_project(name: String):#file_path: String):
	# Clear workspace
	for body in get_bodies():
		bodies_node.remove_child(body)
		body.queue_free()
	# Load project
	var bodies = LampFileManager.load_file(Global.project_data["project_name"])
	await(get_tree().create_timer(0.3).timeout)
	for body in bodies.get_children():
		bodies.remove_child(body)
		body.connect("body_held", _on_body_held)
		body.connect("body_unheld", _on_body_unheld)
		body.connect("body_selected", _on_body_selected)
		body.connect("body_deselected", _on_body_deselected)
		body.init_as_loaded()
		bodies_node.add_child(body, true)
		bodies.queue_free()
	# Save configure data
	Global.project_data = bodies.project_data
#endregion


#region Player
func play(button_pressed: bool):
	state = States.PLAY if button_pressed else States.PAUSE
	if button_pressed:
		get_tree().paused = true
	else:
		get_tree().paused = false

func reload():
	state = States.PLAY
	await load_project(Global.project_data["project_name"])
#endregion


#region Bodies
# TODO - Fix body spawn (Check for another bodies)
func create_body():
	if not selected_item_data == null and not get_tree().paused:
		var item_data = selected_item_data
		var body = item_data.item_scene.instantiate()
		body.connect("body_held", _on_body_held)
		body.connect("body_unheld", _on_body_unheld)
		body.connect("body_selected", _on_body_selected)
		body.connect("body_deselected", _on_body_deselected)
		body.init(cursor, item_data.item_scene)
		bodies_node.add_child(body, true)
		body.hold_body()
		
		selected_item_data = null

func create_copy_body():
	if not buffer_body == null:
		var body = buffer_body.body_scene.instantiate()
		body.connect("body_held", _on_body_held)
		body.connect("body_unheld", _on_body_unheld)
		body.connect("body_selected", _on_body_selected)
		body.connect("body_deselected", _on_body_deselected)
		body.init_as_copy(cursor, buffer_body.body_scene, buffer_body.get_properties(),
				buffer_body.get_edit_properties())
		bodies_node.add_child(body)

func delete_body(body_id: String):
	for body in get_bodies():
		if body.get_id() == body_id:
			body.queue_free()

func delete_selected_body():
	if not selected_body == null:
		if buffer_body == selected_body:
			bodies_node.remove_child(selected_body)
		else:
			selected_body.queue_free()

func copy_body():
	if not buffer_body == null:
		var has_buffer_body: bool
		for body in get_bodies():
			if buffer_body == body:
				has_buffer_body = true
		if not has_buffer_body:
			buffer_body.queue_free()
	# Pack body to buffer
	buffer_body = selected_body

func paste_body():
	create_copy_body()

func clear_select():
	if not selected_body == null:
		selected_body.deselect_body()
		selected_body = null

func get_body(body_id: String) -> NormalBody:
	for body in get_bodies():
		if body.get_id() == body_id:
			return body
	return null

func get_bodies() -> Array[NormalBody]:
	var bodies: Array[NormalBody]
	for body in bodies_node.get_children():
		bodies.push_back(body)
	return bodies

func is_any_body_mouse_inside() -> bool:
	for body in get_bodies():
		if body.is_mouse_inside() and not body.is_held():
			return true
	return false
#endregion

func get_cursor():
	return cursor


#region Foreground
func is_lab_mouse_inside() -> bool:
	return lab.is_mouse_inside()
#endregion
