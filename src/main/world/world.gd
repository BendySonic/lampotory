extends Node2D
# Class for world


enum STATES {STATIC, PLAY, PAUSE}
const WORLD_PATH := "res://data/"
# Data.
var _state: int = STATES.STATIC
var _bodies_count: int = 0
var _speed: float = 1
var _has_selected_body := false
# GUI.
var create_properties: Callable
var delete_properties: Callable
# Main.
var get_mode_data: Callable
var is_mode: Callable


func _on_body_pressed(body_properties: Dictionary, body_id: int):
	select_body(body_id)
	delete_properties.call()
	create_properties.call(body_properties)


# Behavior
func play_world(button_pressed: bool):
	_state = STATES.PLAY if button_pressed else STATES.PAUSE
	for body in get_children():
		if button_pressed:
			body.play()
		else:
			body.pause()

func reload_world():
	_state = STATES.STATIC
	for body in get_children():
		body.reload()

func save_world(file_path: String):
	var bodies_properties: Array[Dictionary]
	for body in get_children():
		bodies_properties.push_back(body.get_properties())
	LampFileManager.save_file(WORLD_PATH + file_path, bodies_properties)

func load_world(file_path: String):
	return LampFileManager.load_file(WORLD_PATH + file_path)

func create_body(body_data: BodyResource):
	_bodies_count += 1
	body_data.id = _bodies_count
	
	var body = (
			get_mode_data.call().body_scenes[body_data.body_name].instantiate()
	)
	body.construct(body_data)
	body.get_mode_data = get_mode_data
	body.get_speed = get_speed
	body.reload_world = reload_world
	body.body_pressed.connect(_on_body_pressed)
	if is_mode.call("mechanic_1d"):
		body.position = Vector2(get_global_mouse_position().x, 0)
	add_child(body)

func delete_body(body_id: int):
	for body in get_children():
		if body.get_id() == body_id:
			body.queue_free()

func select_body(body_id:int):
	deselect_bodies()
	for body in get_children():
		if body.get_id() == body_id:
			_has_selected_body = true
			body.select_body()

func deselect_bodies():
	_has_selected_body = false
	for body in get_children():
		body.deselect_body()


# Getters
func get_body(body_id: int) -> BodyBase:
	for body in get_children():
		if body.get_id() == body_id:
			return body
	return null

func get_selected_body() -> BodyBase:
	for body in get_children():
		if body.is_selected():
			return body
	return null

func get_bodies_count() -> int:
	return _bodies_count

func has_selected_body() -> bool:
	return _has_selected_body

func get_bodies() -> Array:
	return get_children()

func get_speed() -> float:
	return _speed
