extends Node2D
# Class for world

# -----------------------------------------------------------------------------
enum STATES {STATIC, PLAY, PAUSE}
# Properties
var _state := STATES.STATIC
var _bodies_count := 0
var speed := 1
var _has_selected_body := false
# GUI
var create_properties: Callable
var delete_properties: Callable
var block_workspace_area_input: Callable
# Main
var get_mode_data: Callable
var is_mode: Callable

# -----------------------------------------------------------------------------
func _ready():
	LampSignalManager.play_toggled.connect(_on_play_toggled)
	LampSignalManager.reload_pressed.connect(_on_reload_pressed)
	LampSignalManager.body_pressed.connect(_on_body_pressed)


# Signals
func _on_play_toggled(button_pressed: bool):
	_state = STATES.PLAY if button_pressed else STATES.PAUSE
	for body in get_children():
		if button_pressed:
			body.play()
		else:
			body.pause()

func _on_reload_pressed():
	_state = STATES.STATIC
	for body in get_children():
		body.reload()

func _on_body_pressed(body_properties: Dictionary, body_id: int):
	block_workspace_area_input.call() # Block body deselect on input
	var local_ru = get_mode_data.call().local_ru
	
	select_body(body_id)
	delete_properties.call()
	create_properties.call(body_properties, body_id)


# Behavior
func create_body(body_data: BodyResource):
	_bodies_count += 1
	body_data.id = _bodies_count
	
	var body = (
			get_mode_data.call().body_scenes[body_data.body_name].instantiate()
	)
	body.construct(body_data)
	body.get_mode_data = get_mode_data
	body.get_speed = get_speed
	if is_mode.call("mechanic_1d"):
		body.position = Vector2(get_global_mouse_position().x, 0)
	add_child(body)

func deselect_bodies():
	_has_selected_body = false
	for body in get_children():
		body.deselect_body()

func select_body(body_id:int):
	deselect_bodies()
	for body in get_children():
		if body.get_id() == body_id:
			_has_selected_body = true
			body.select_body()


# Getters
func get_bodies_count():
	return _bodies_count

func get_has_selected_body():
	return _has_selected_body

func get_bodies():
	return get_children()

func get_speed():
	return speed
