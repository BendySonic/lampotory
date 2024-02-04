class_name RigidBodyPlus
extends RigidBody2D
# Gives safe access to RigidBody2D and has other features
# (etc. is_mouse_inside)

signal rigid_body_defined()

var physics_state: PhysicsDirectBodyState2D
var body_defined := false
var mouse_inside: bool:
	get = is_mouse_inside

func _init():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

#region PhysicsState define
func _integrate_forces(state):
	physics_state = state
	body_defined = true
	emit_signal("rigid_body_defined")
#endregion


#region Mouse enter/exit
func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false

func is_mouse_inside():
	return mouse_inside
#endregion
