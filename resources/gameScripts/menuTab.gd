class_name menuTab extends PanelContainer

#private
var mouse_inside:bool = false

func _ready():
	pass

func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
	
#public
func is_mouse_inside():
	return mouse_inside
