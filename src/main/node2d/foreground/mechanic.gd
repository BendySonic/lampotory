extends Node2D
# Class for foreground (enviroment) of laboratory

var mouse_inside: bool:
	get = is_mouse_inside


func _on_static_body_2d_mouse_entered():
	mouse_inside = true

func _on_static_body_2d_mouse_exited():
	mouse_inside = false

func is_mouse_inside():
	return mouse_inside
