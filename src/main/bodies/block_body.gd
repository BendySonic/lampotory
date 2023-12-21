class_name BlockBody
extends NormalBody


func _ready():
	super()
	connect("rigid_body_defined", sync_position, CONNECT_ONE_SHOT)

func sync_position():
	print("Why")
	global_position = get_global_mouse_position()
