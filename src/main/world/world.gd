extends Node2D
# Class for world

# -----------------------------------------------------------------------------
enum STATES {STATIC, PLAY, PAUSE}
# Properties
var _state: int = STATES.STATIC
var _bodies_count: int = 0
var _has_selected_body: bool = false

# Main
var get_mode_data: Callable
var is_mode: Callable

# -----------------------------------------------------------------------------
func _ready():
	LampSignalManager.play_pressed.connect(_on_play_pressed)
	LampSignalManager.reload_pressed.connect(_on_reload_pressed)


# Signals
func _on_play_pressed():
	_state = STATES.PAUSE if _state == STATES.PLAY else STATES.PLAY
	for body in get_children():
		if _state == STATES.PLAY:
			body.play()
		else:
			body.pause()

func _on_reload_pressed():
	_state = STATES.STATIC
	for body in get_children():
		body.reload()


# Behavior
func create_body(body_data: BodyResource):
	_bodies_count += 1
	body_data.id = _bodies_count
	
	var body = (
			get_mode_data.call().body_scenes[body_data.body_name].instantiate()
	)
	body.construct(body_data)
	if is_mode.call("mechanic_1d"):
		body.position = Vector2(get_global_mouse_position().x, 0)
	body.z_index = 5
	body.get_mode_data = get_mode_data
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
