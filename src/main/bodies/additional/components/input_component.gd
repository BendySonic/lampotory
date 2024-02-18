class_name InputComponent
extends Node

enum HoldType {STATIC_AXIS, STATIC, PIN}

@export var input_body: PhysicsBody2D
@export var hold_type: HoldType
@export var disabled: bool
@export var is_rotatable: bool = false
@export var rotate_speed: float = 10.5

var rotate_timer: Timer = Timer.new()

var is_held: bool
var releative_drag_position: Vector2


func _ready():
	get_parent().connect("input_event", _on_input_event)
	rotate_timer.connect("timeout", _on_scroll_timer_timeout)
	rotate_timer.wait_time = 0.05
	add_child(rotate_timer)

func _physics_process(delta):
	# Move by axis
	if not disabled:
		if input_body is NormalBody:
			if is_held and is_hold_type(HoldType.STATIC_AXIS):
				input_body.set_velocity(Vector2(
						(
								(Global.cursor.global_position.x
								- (input_body.global_position.x 
								+ releative_drag_position.x)) * 5
						),
						0
				))

func _input(event):
	if not disabled:
		if event is InputEventMouseButton:
			if event.button_index == 1:
				if not event.is_pressed():
					if is_held:
						unhold_body()
			# Rotation
			if is_held:
				if event.button_index == 4:
					if event.is_pressed():
						if is_rotatable:
							rotate_timer.stop()
							input_body.angular_velocity = PI / 6 * rotate_speed
							rotate_timer.start()
				elif event.button_index == 5:
					if event.is_pressed():
						if is_rotatable:
							rotate_timer.stop()
							input_body.angular_velocity = -PI / 6 * rotate_speed
							rotate_timer.start()


func _on_input_event(viewport, event, _shape_idx):
	if not disabled:
		if event is InputEventMouseButton:
			if event.button_index == 1:
				if event.is_pressed():
					if not is_held:
						hold_body()
						viewport.set_input_as_handled()
			elif event.button_index == 2:
					if event.is_pressed():
						if input_body is NormalBody:
							if input_body.is_selected():
								deselect_body()
							else:
								select_body()

func _on_scroll_timer_timeout():
	input_body.angular_velocity = 0
	rotate_timer.stop()

func hold_body():
	is_held = true
	deselect_body()
	# Hold work
	if is_hold_type(HoldType.STATIC_AXIS):
		input_body.collision_layer = 2
		input_body.collision_mask = 2
		# ANDROID ##############################
		if OS.get_name() == "Android":
			Global.cursor.global_position = Global.cursor.get_global_mouse_position()
			await get_tree().create_timer(0.05).timeout
		########################################
		releative_drag_position = input_body.to_local(Global.cursor.global_position)
		input_body.set_deferred("freeze", false)
	else:
		Global.cursor.hold_body(input_body)
		if is_hold_type(HoldType.STATIC):
			input_body.set_deferred("lock_rotation", true)
	# Visual
	input_body.modulate = Color(0.663, 0.804, 1)
	# Send to body
	if input_body is NormalBody:
		if is_hold_type(HoldType.STATIC) or is_hold_type(HoldType.STATIC_AXIS):
			input_body.set_static_hold()
		else:
			input_body.set_pin_hold()

func unhold_body():
	if is_held:
		is_held = false
		# Unhold work
		if is_hold_type(HoldType.STATIC_AXIS):
			input_body.collision_layer = 5
			input_body.collision_mask = 1
			releative_drag_position =  Vector2(0, 0)
			input_body.set_deferred("freeze", true)
		else:
			Global.cursor.unhold_body()
			if is_hold_type(HoldType.STATIC):
				input_body.set_deferred("lock_rotation", false)
		# Visual
		input_body.modulate = Color(1, 1, 1)
		# Send to body
		if input_body is NormalBody:
			input_body.set_unhold()

func is_hold_type(hold_type_arg: HoldType):
	return (hold_type == hold_type_arg)

func set_pin_hold_type():
	hold_type = HoldType.PIN


func select_body():
	if input_body is NormalBody:
		if not input_body.is_selected():
			input_body.set_select()
			# Visual
			#main_body.select.visible = true

func deselect_body():
	if input_body is NormalBody:
		if input_body.is_selected():
			input_body.set_deselect()
			# Visual
			#main_body.select.visible = false
