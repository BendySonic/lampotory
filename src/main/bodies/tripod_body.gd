class_name TripodBody
extends NormalBody

@export var start_height: float

var level_position: Vector2


func _enter_tree():
	var tripod_level := get_node("PillarBody/TripodLevel")
	if is_loaded:
		tripod_level.position.y = level_position.y

func _on_tripod_level_unhold(level_position_arg: Vector2):
	level_position = level_position_arg

func _set_start_position():
	super()
	if not is_loaded:
		global_position = Vector2(cursor.global_position.x, start_height)


func hold_body():
	super()
	collision_layer = 2
	collision_mask = 2
	set_deferred("lock_rotation", true)
	set_deferred("freeze", false)

func unhold_body():
	super()
	collision_layer = 5
	collision_mask = 1
	set_deferred("freeze", true)
