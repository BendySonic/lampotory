class_name GUICursor
extends CharacterBody2D


@onready var icon: Sprite2D = get_node("Sprite2D")
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")

func _physics_process(delta):
	global_position = get_global_mouse_position()

func hold_body(body: PhysicsBody2D):
	# ANDROID ##############################
	if OS.get_name() == "Android":
		global_position = get_global_mouse_position()
	# Cursor hold free movable bodies
		await get_tree().create_timer(0.1).timeout
	########################################
	pin_joint.set_deferred("node_a", pin_joint.get_path_to(self))
	pin_joint.set_deferred("node_b", pin_joint.get_path_to(body))

func unhold_body():
	# ANDROID ##############################
	if OS.get_name() == "Android":
		global_position = get_global_mouse_position()
		await get_tree().create_timer(0.05).timeout
	########################################
	pin_joint.set_deferred("node_a", "")
	pin_joint.set_deferred("node_b", "")

func is_hold(body: PhysicsBody2D):
	return (
			pin_joint.node_a == pin_joint.get_path_to(body)
			or pin_joint.node_b == pin_joint.get_path_to(body)
	)
