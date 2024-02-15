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
var held_body: Variant
# Data containers durning body spawn
var selected_item_data: Variant:
	get: return selected_item_data

var buffer_body: Variant:
	get: return buffer_body

var camera_drag_start_position: Vector2
var is_camera_ready_to_drag: bool
var is_camera_drag: bool
var is_camera_dragged: bool
var releative_drag_position: Vector2

var is_display_vector: bool = false

@onready var bodies_node: Node = get_node("Bodies")
@onready var lab_node: Node = get_node("Enviroment/Lab")
@onready var camera: Camera2D = get_node("Camera/Camera2D")
@onready var cursor: GUICursor = get_node("GUICursor"):
	get = get_cursor



func _ready():
	Global.cursor = cursor

#region Input
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_released():
			if not is_any_body_mouse_inside() and not is_camera_dragged:
				emit_signal("void_pressed", event)
			is_camera_dragged = false
#endregion

# Camera
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_camera_ready_to_drag = true
				camera_drag_start_position = event.global_position
			elif event.is_released():
				is_camera_ready_to_drag = false
				is_camera_drag = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if not camera.zoom > Vector2(2, 2) and held_body == null:
				camera.zoom *= Vector2(1.05, 1.05)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and held_body == null:
			if not camera.zoom < Vector2(0.5, 0.5):
				camera.zoom /= Vector2(1.05, 1.05)
	if event is InputEventMouseMotion:
		if is_camera_ready_to_drag and (event.global_position - camera_drag_start_position).length() > 20:
			is_camera_drag = true
			releative_drag_position = camera.to_local(cursor.global_position)
			is_camera_dragged = true

func _process(delta):
	# Camera
	if is_camera_drag:
		camera.global_position += (-camera.to_local(cursor.global_position) +
				releative_drag_position)
		if camera.global_position.x > 2000:
			camera.global_position.x = 2000
		if camera.global_position.x < -2000:
			camera.global_position.x = -2000
		if camera.global_position.y > 200:
			camera.global_position.y = 200
		if camera.global_position.y < -4000:
			camera.global_position.y = -4000
		releative_drag_position += (camera.to_local(cursor.global_position) - 
				releative_drag_position)

# Draw forces
func _physics_process(delta):
	# Forces
	queue_redraw()

func _draw():
	for body in bodies_node.get_children():
		var gravity_force = body.mass * Vector2(0, 980) / 20
		if not gravity_force.length() <= 2 and is_display_vector:
			var gravity_force_position = body.to_global(body.center_of_mass) + gravity_force
			draw_line(body.to_global(body.center_of_mass), gravity_force_position, Color.DEEP_SKY_BLUE, 5, true)
			draw_circle(body.to_global(body.center_of_mass), 5, Color.LIME_GREEN)
			draw_line(
					gravity_force_position + Vector2(-10, -10),
					gravity_force_position, Color.LIME_GREEN, 5, true)
			draw_line(
					gravity_force_position + Vector2(10, -10),
					gravity_force_position, Color.LIME_GREEN, 5, true)
			draw_circle(gravity_force_position + Vector2(0, -1), 4, Color.LIME_GREEN)


#region Body input
func _on_body_held(body: NormalBody):
	held_body = body
	emit_signal("body_held", body)

func _on_body_unheld(body: NormalBody):
	held_body = null
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
func save_project(name: String, theme: String):
	Global.project_data["project_name"] = name
	Global.project_data["project_theme"] = theme
	Global.project_data["is_saved"] = true
	LampFileManager.save_file(bodies_node, name)

func load_project(name: String):#file_path: String):
	if not Global.project_data["is_saved"]:
		return
	# Clear workspace
	for body in get_bodies():
		bodies_node.remove_child(body)
		body.queue_free()
	# Load project
	var bodies = LampFileManager.load_file(Global.project_data["project_name"])
	await(get_tree().create_timer(0.3).timeout)
	for body in bodies.get_children():
		connect_body_signals(body)
		bodies.remove_child(body)
		bodies_node.add_child(body, true)
	bodies.queue_free()

func set_mode(mode: ModeResource):
	var new_lab = mode["lab_scene"].instantiate()
	lab_node.add_child(new_lab)
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
func create_body():
	if not selected_item_data == null and not get_tree().paused:
		var item_data = selected_item_data
		var body = new_body(item_data.item_scene)
		body.create_body()
		bodies_node.add_child(body, true)
		body.hold_body()
		
		selected_item_data = null

func create_copy_body():
	if not buffer_body == null:
		var body_scene = ResourceLoader.load(buffer_body.body_scene_path)
		var body = new_body(body_scene)
		body.create_copy_body(buffer_body.get_properties())
		bodies_node.add_child(body)

func delete_body(body_id: String):
	for body in get_bodies():
		if body.get_id() == body_id:
			body.queue_free()

func clear_bodies():
	for body in get_bodies():
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

func is_any_body_selected():
	for body in get_bodies():
		if body.is_selected() and not body.is_held():
			return true
	return false
#endregion


#region New body
func new_body(body_scene: PackedScene):
	var body = body_scene.instantiate()
	connect_body_signals(body)
	return body

func connect_body_signals(body: NormalBody):
	body.connect("body_static_held", _on_body_held)
	body.connect("body_pin_held", _on_body_held)
	body.connect("body_unheld", _on_body_unheld)
	body.connect("body_selected", _on_body_selected)
	body.connect("body_deselected", _on_body_deselected)
#endregion


func display_vector(toggled_on: bool):
	is_display_vector = toggled_on

func get_cursor():
	return cursor
