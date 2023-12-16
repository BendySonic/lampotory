extends Node2D
# Class for foreground (enviroment) of laboratory

var is_mouse_inside: bool




func _on_static_body_2d_mouse_entered():
	is_mouse_inside = true

func _on_static_body_2d_mouse_exited():
	is_mouse_inside = false
