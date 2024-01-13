class_name RigidBodyPlus
extends RigidBody2D
# Gives safe access to RigidBody2D and has other features
# (etc. is_mouse_inside)

signal rigid_body_defined()

var physics_state: PhysicsDirectBodyState2D
var body_defined := false
var mouse_inside: bool:
	get = is_mouse_inside


#region PhysicsState define
func _integrate_forces(state):
	physics_state = state
	body_defined = true
	emit_signal("rigid_body_defined")
#endregion


#region Mouse enter/exit
func _mouse_enter():
	mouse_inside = true

func _mouse_exit():
	mouse_inside = false

func is_mouse_inside():
	return mouse_inside
#endregion
