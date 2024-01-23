class_name GUICursor
extends CharacterBody2D


@onready var icon: Sprite2D = get_node("Sprite2D")
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")

func _physics_process(delta):
	velocity = (get_global_mouse_position() - global_position) * 30
	move_and_slide()

func hold_body(body: PhysicsBody2D):
	# Cursor hold free movable bodies
	pin_joint.node_a = pin_joint.get_path_to(self)
	pin_joint.node_b = pin_joint.get_path_to(body)

func unhold_body():
	pin_joint.node_a = ""
	pin_joint.node_b = ""

func is_hold(body: PhysicsBody2D):
	return (
			pin_joint.node_a == pin_joint.get_path_to(body)
			or pin_joint.node_b == pin_joint.get_path_to(body)
	)
