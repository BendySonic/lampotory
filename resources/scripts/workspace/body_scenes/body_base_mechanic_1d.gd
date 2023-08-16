class_name BodyBaseMechanic1D
extends BodyBase
## Base class for ALL "mechanic_1d" bodies

func play():
	_state = STATES.PLAY
	velocity.x = _realtime_properties["speed"]


func pause():
	_state = STATES.PAUSE
	velocity = Vector2(0, 0)


func reload():
	_state = STATES.START
	velocity = Vector2(0, 0)
	_realtime_properties = _properties.duplicate()
	position.x = _properties["position"]
