class_name TripodBody
extends NormalBody

@export var floor_height: float
@export var tripod_height: Vector2 = Vector2(0, -340)
@onready var tripod_level := get_node("PillarBody/TripodLevel")

func prepare_body():
	set_start_position()
	tripod_level.position.y = tripod_height.y
	set_deferred("freeze", true)

func _on_tripod_level_unhold(tripod_height_arg: Vector2):
	tripod_height = tripod_height_arg

func set_start_position():
	if not is_loaded:
		global_position = Vector2(Global.cursor.global_position.x, floor_height)
