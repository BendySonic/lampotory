class_name TripodBody
extends NormalBody

@export var start_height: float
@export var tripod_level_start_position: Vector2 = Vector2(0, -340)
@onready var tripod_level := get_node("PillarBody/TripodLevel")

func _ready():
	super()
	tripod_level.position.y = tripod_level_start_position.y

func _on_tripod_level_unhold(level_position_arg: Vector2):
	tripod_level_start_position = level_position_arg

func _set_start_position():
	super()
	if not is_loaded:
		global_position = Vector2(Global.cursor.global_position.x, start_height)

func _on_body_held(body):
	collision_layer = 2
	collision_mask = 2
	set_deferred("freeze", false)


func _on_body_unheld(body):
	collision_layer = 5
	collision_mask = 1
	set_deferred("freeze", true)
