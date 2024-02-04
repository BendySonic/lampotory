class_name StaticNormalBody
extends NormalBody

@export var floor_height: float = 200


func prepare_body():
	set_start_position()
	
	set_deferred("freeze", true)
	linear_velocity = Vector2(0, 0)


func set_start_position():
	if not is_loaded:
		global_position = Vector2(Global.cursor.global_position.x, floor_height)
