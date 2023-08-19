class_name BodyMechanic1D
extends BodyBaseMechanic1D
# Classic Body1D for 1D movement with mass, speed, acceleration

# -----------------------------------------------------------------------------
var can_collide: bool = false

@onready var right_raycast = get_node("Right")

# -----------------------------------------------------------------------------
func _ready():
	super()
	_extra_base_properties = ["mass", "speed", "acceleration"]
	_extra_base_realtime_properties = ["path"]
	# Create properties and add to "_properties" (BaseBody class)
	_reload_properties()
	_reload_realtime_properties()
	_set_values()


# Physics interactions
func _process(_delta):
	if _state == STATES.PLAY:
		if right_raycast.is_colliding() and not can_collide:
			can_collide = !can_collide
		elif right_raycast.is_colliding() and can_collide:
			can_collide = !can_collide
			impulse_manager()
	super(_delta)

# body impulse manage
func impulse_manager():
	var target = right_raycast.get_collider()
	var m1 = _realtime_properties["mass"]
	var v1 = _realtime_properties["speed"]
	var m2 = target.get_realtime_properties()["mass"]
	var v2 = target.get_realtime_properties()["speed"]
	
	_realtime_properties["speed"] = impulse_math(m1, m2, v1, v2)
	target.set_realtime_property("speed", impulse_math(m2, m1, v2, v1))

func impulse_math(m1: float, m2: float, v1: float, v2: float) -> float:
	return ((m1 - m2) / (m1 + m2)) * v1 + (2*m2 / (m1 + m2)) * v2


# Body player
func reload():
	can_collide = false
	super()
