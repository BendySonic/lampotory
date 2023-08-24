class_name BodyMechanic1D
extends BodyBaseMechanic1D
# Classic Body1D for 1D movement with mass, speed, acceleration


func _ready():
	super()
	_extra_base_properties = ["mass", "speed"]
	_extra_base_realtime_properties = ["path"]
	
	_reload_properties()
	_reload_realtime_properties()
	_set_values()


# Body physics interactions
func _physics_process(delta):
	if _kinematic_collision is KinematicCollision2D and _ready_to_collide:
		var target = _kinematic_collision.get_collider()
		if target.position.x > position.x:
			_ready_to_collide = false
			_impulse_manager(target)
	if (
			not _kinematic_collision is KinematicCollision2D
			and not _ready_to_collide
		):
		_ready_to_collide = true
	super(delta)

## Body impulse manage
func _impulse_manager(target: Node2D):
	var m1 = _data.realtime_properties["mass"]
	var v1 = _data.realtime_properties["speed"]
	var m2 = target.get_realtime_property("mass")
	var v2 = target.get_realtime_property("speed")
	
	_data.realtime_properties["speed"] = _impulse_math(m1, m2, v1, v2)
	target.set_realtime_property("speed", _impulse_math(m2, m1, v2, v1))

## Body impulse math
func _impulse_math(m1: float, m2: float, v1: float, v2: float) -> float:
	var result = ((m1 - m2) / (m1 + m2)) * v1 + (2*m2 / (m1 + m2)) * v2
	if m1 + m2 == 0:
		return 0
	else:
		return result
