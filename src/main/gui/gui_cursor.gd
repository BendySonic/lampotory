class_name GUICursor
extends CharacterBody2D


var held_body: Variant = null
var drag_position: Vector2

@onready var icon: Sprite2D = get_node("Sprite2D")
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")


func _physics_process(_delta):
	# Axis move for special bodies
	if not held_body == null:
		if held_body.is_in_group("tripod"):
			held_body.set_velocity(Vector2(
					(global_position.x - (held_body.global_position.x + drag_position.x)) * 5,
					0
			))
	# Cursor move
	velocity = (get_global_mouse_position() - global_position) * 25
	move_and_slide()

func hold_body(body: NormalBody):
	# Cursor hold free movable bodies
	if not body.is_in_group("tripod"):
		pin_joint.node_a = pin_joint.get_path_to(self)
		pin_joint.node_b = pin_joint.get_path_to(body)
	drag_position = body.to_local(global_position)
	held_body = body

func unhold_body():
	pin_joint.node_a = ""
	pin_joint.node_b = ""
	held_body = null
