class_name TripodBody
extends NormalBody

@export var level_position: Vector2

@onready var tripod_level := get_node("PillarBody/TripodLevel")

func _ready():
	super()
	if not is_loaded:
		global_position = Vector2(cursor.global_position.x, 440)
	else:
		tripod_level.global_position = level_position

func _physics_process(delta):
	level_position = tripod_level.global_position

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
