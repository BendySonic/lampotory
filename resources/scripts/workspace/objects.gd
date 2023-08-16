class_name Objects
extends Node2D
## Class for objects managment

# -----------------------------------------------------------------------------
enum STATES {STATIC, PLAY, PAUSE}

var state: int = STATES.STATIC
var count: int = 0
var selected: bool = false

var workspace: Node

# -----------------------------------------------------------------------------
func _ready():
	LampSignalManager.play_pressed.connect(_on_play_pressed)
	LampSignalManager.reload_pressed.connect(_on_reload_pressed)


func _on_play_pressed():
	state = STATES.PAUSE if state == STATES.PLAY else STATES.PLAY
	for body in get_children():
		if state == STATES.PLAY:
			body.play()
		else:
			body.pause()


func _on_reload_pressed():
	state = STATES.STATIC
	for body in get_children():
		body.reload()


func create_body(body_data: BodyResource):
	var body = (
			workspace.mode_data.body_scenes[body_data.body_name].instantiate()
	)
	if workspace.MODES[workspace.mode] == "mechanic_1d":
		body.position = Vector2(get_global_mouse_position().x, 0)
	body.construct(body_data, workspace.mode_data)
	add_child(body)


func deselect_bodies():
	selected = false
	for body in get_children():
		body.deselect_body()


func select_body(body_id:int):
	for body in get_children():
		if body.get_id() == body_id:
			selected = true
			body.select_body()
