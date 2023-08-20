class_name BodyMechanic1D
extends BodyBaseMechanic1D
## Classic Body1D for 1D movement with mass, speed, acceleration


func _ready():
	super()
	_extra_base_properties = ["mass", "speed", "acceleration"]
	_extra_base_realtime_properties = ["path"]
	# Create properties and add to "_properties" (BaseBody class)
	_reload_properties()
	_reload_realtime_properties()
	_set_values()


# Physics interactions
func _physics_process(delta):
	super(delta)
	if not kinematic_collision == null:
		impulse_manager(kinematic_collision.get_collider())

## Body impulse manage
func impulse_manager(target: Node2D):
	var m1 = _data.realtime_properties["mass"]
	var v1 = _data.realtime_properties["speed"]
	var m2 = target.get_realtime_properties()["mass"]
	var v2 = target.get_realtime_properties()["speed"]
	
	_data.realtime_properties["speed"] = impulse_math(m1, m2, v1, v2)
	target.set_realtime_property("speed", impulse_math(m2, m1, v2, v1))

## Body impulse math
func impulse_math(m1: float, m2: float, v1: float, v2: float) -> float:
	var result = ((m1 - m2) / (m1 + m2)) * v1 + (2*m2 / (m1 + m2)) * v2
	if m1 + m2 == 0:
		return 0
	else:
		return result
