class_name CameraManager
extends Camera2D

# Camera drag
var can_drag := true

var is_camera_ready_to_drag: bool
var is_camera_drag: bool
var is_camera_dragged: bool

var camera_drag_start_position: Vector2
var releative_drag_position: Vector2

var camera_speed: float

# Camera zoom
var can_zoom := true

var one_touch: Vector2
var one_touch_rel: Vector2
var two_touch: Vector2
var two_touch_rel: Vector2

var zoom_speed: float


func _ready():
	if OS.get_name() == "Android":
		camera_speed = 2
		zoom_speed = 1.01
	else:
		camera_speed = 1
		zoom_speed = 1.05

func _unhandled_input(event):
	# PC
	# Drag
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			manage_camera_drag(event)
		# Zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			manage_camera_zoom(true)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			manage_camera_zoom(false)
	if event is InputEventMouseMotion:
		change_camera_position(event)
	# ANDROID ###########################################
	# Drag
	if event is InputEventScreenTouch:
		manage_camera_drag(event)
		if not event.is_pressed():
			one_touch = Vector2(0, 0)
			two_touch = Vector2(0, 0)
			one_touch_rel = Vector2(0, 0)
			two_touch_rel = Vector2(0, 0)
	if event is InputEventScreenDrag:
		# Zoom
		match event.index:
			0:
				one_touch = event.position
				one_touch_rel = event.relative
			1:
				two_touch = event.position
				two_touch_rel = event.relative
		
		if (
			(one_touch_rel + two_touch_rel).length() <
			one_touch_rel.length() * 0.7
		):
			if (
					(one_touch - two_touch).length() <
					((one_touch + one_touch_rel) - (two_touch + two_touch_rel)).length()
			):
				manage_camera_zoom(true)
			else:
				manage_camera_zoom(false)
		
		if two_touch == Vector2(0, 0):
			change_camera_position(event)
	#########################################################

func _process(delta):
	# ANDROID #############################################
	if OS.get_name() == "Android":
		if two_touch == Vector2(0, 0):
			drag_camera_to_position()
	########################################################
	else:
		drag_camera_to_position()

func manage_camera_drag(event):
	if can_drag:
		if event.is_pressed():
			is_camera_ready_to_drag = true
			camera_drag_start_position = event.position
		elif event.is_released():
			is_camera_ready_to_drag = false
			is_camera_drag = false

func manage_camera_zoom(is_zoom_in: bool):
	if can_zoom:
		if is_zoom_in:
			if not zoom > Vector2(2, 2) and can_zoom:
				zoom *= Vector2(zoom_speed, zoom_speed)
		else:
			if not zoom < Vector2(0.5, 0.5) and can_zoom:
				zoom /= Vector2(zoom_speed, zoom_speed)

func change_camera_position(event):
	if can_drag:
		if is_camera_ready_to_drag and (event.position - camera_drag_start_position).length() > 20:
			is_camera_drag = true
			releative_drag_position = to_local(Global.cursor.global_position)
			is_camera_dragged = true

func drag_camera_to_position():
	if can_drag:
		if is_camera_drag:
			global_position += (-to_local(Global.cursor.global_position) +
					releative_drag_position) * camera_speed
			if global_position.x > 2000:
				global_position.x = 2000
			if global_position.x < -2000:
				global_position.x = -2000
			if global_position.y > 300:
				global_position.y = 300
			if global_position.y < -4000:
				global_position.y = -4000
			releative_drag_position += (to_local(Global.cursor.global_position) - 
					releative_drag_position)
#endregion

func block():
	can_zoom = false
	can_drag = false

func unblock():
	can_zoom = true
	can_drag = true
