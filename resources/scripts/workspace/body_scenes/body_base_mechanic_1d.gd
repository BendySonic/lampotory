class_name BodyBaseMechanic1D
extends BodyBase
## Base class for ALL "mechanic_1d" bodies

# -----------------------------------------------------------------------------
# Realtime statistics
var path: float # Physics path. Literally sum of all body movements.

# -----------------------------------------------------------------------------
func _process(delta):
	super(delta)
	# speed += acceleration
	if _state == STATES.PLAY:
		_realtime_properties["speed"] += (
				_realtime_properties["acceleration"] * delta
		)
		velocity.x = _realtime_properties["speed"]
	# path += veclocity.x
	path += absf(velocity.x) * delta


func play():
	_state = STATES.PLAY
	velocity.x = _realtime_properties["speed"]


func pause():
	_state = STATES.PAUSE
	velocity = Vector2(0, 0)


func reload():
	_state = STATES.START
	velocity = Vector2(0, 0)
	
	position.x = _properties["position"]
	
	_realtime_properties = _properties.duplicate()
	path = 0
