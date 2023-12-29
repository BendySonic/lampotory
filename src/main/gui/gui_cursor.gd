class_name GUICursor
extends CharacterBody2D


@onready var icon: Sprite2D = get_node("Sprite2D")
@onready var pin_joint: PinJoint2D = get_node("PinJoint2D")


func _input(event):
	print("Mouse event", event.global_position)

func _physics_process(_delta):
	velocity = (get_global_mouse_position() - global_position) * 25
	move_and_slide()

func hold_body(body: NormalBody):
	if body.is_in_group("free_move"):
		pin_joint.node_a = pin_joint.get_path_to(self)
		pin_joint.node_b = pin_joint.get_path_to(body)

func unhold_body():
	pin_joint.node_a = ""
	pin_joint.node_b = ""
