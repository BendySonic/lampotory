class_name InputComponent
extends Node

enum States {NORMAL, STATIC_HOLD, PIN_HOLD, SELECTED}
enum HoldType {AXIS, STATIC, PIN}

@export var main_body: NormalBody
@export var hold_type: HoldType

var releative_drag_position: Vector2

func _ready():
	get_parent().connect("input_event", _on_input_event)

func _physics_process(delta):
	if main_body.is_held() and is_hold_type(HoldType.AXIS):
		main_body.set_velocity(Vector2(
				(
						(Global.cursor.global_position.x
						- (main_body.global_position.x 
						+ releative_drag_position.x)) * 5
				),
				0
		))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.is_pressed():
				if main_body.is_held():
					unhold_body()

func _on_input_event(viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				if not main_body.is_held():
					hold_body()
					viewport.set_input_as_handled()
		elif event.button_index == 2:
				if event.is_pressed():
					if main_body.is_selected():
						deselect_body()
					else:
						select_body()

func hold_body():
	if is_hold_type(HoldType.STATIC) or is_hold_type(HoldType.AXIS):
		main_body.set_static_hold()
	else:
		main_body.set_pin_hold()
	deselect_body()
	if is_hold_type(HoldType.AXIS):
		releative_drag_position = main_body.to_local(Global.cursor.global_position)
	else:
		Global.cursor.hold_body(main_body)
		if is_hold_type(HoldType.STATIC):
			main_body.set_deferred("lock_rotation", true)
	# Visual effect
	main_body.modulate = Color(0.663, 0.804, 1)

func unhold_body():
	if main_body.is_held():
		main_body.set_unhold()
		if not is_hold_type(HoldType.AXIS):
			Global.cursor.unhold_body()
			main_body.set_deferred("lock_rotation", false)
		# Visual effect
		main_body.modulate = Color(1, 1, 1)

func is_hold_type(hold_type_arg: HoldType):
	return hold_type == hold_type_arg


func select_body():
	if not main_body.is_selected():
		main_body.set_selected()
		# Visual select
		main_body.select.visible = true
		main_body.emit_signal("body_selected", main_body)

func deselect_body():
	if main_body.is_selected():
		main_body.set_deselected()
		# Visual deselect
		main_body.select.visible = false
		main_body.emit_signal("body_deselected", main_body)
