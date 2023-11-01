class_name RigidBodyPlus
extends RigidBody2D
# Gives safe access to RigidBody2D and has other features
# (etc. is_mouse_inside)

signal body_defined()

var mouse_inside: bool:
	get = is_mouse_inside
var physics_state: PhysicsDirectBodyState2D


func _ready():
	mouse_entered.connect(func(): mouse_inside = true)
	mouse_exited.connect(func(): mouse_inside = false)

func _integrate_forces(state):
	physics_state = state
	emit_signal("body_defined")

func is_mouse_inside():
	return mouse_inside
