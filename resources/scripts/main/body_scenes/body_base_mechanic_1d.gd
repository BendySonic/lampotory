class_name BodyBaseMechanic1D
extends BodyBase
## Base class for ALL "mechanic_1d" bodies


# Speed and path
func _process(delta):
	if _state == STATES.PLAY:
		# Speed
		_realtime_properties["speed"] += (
				_realtime_properties["acceleration"] * delta
		)
		# Path
		_realtime_properties["path"] += absf(velocity.x) * delta
		# Moving
		velocity.x = _realtime_properties["speed"]
		move_and_collide(velocity * delta)


# Body player
func play():
	_state = STATES.PLAY
	velocity.x = _realtime_properties["speed"]

func pause():
	_state = STATES.PAUSE
	velocity.x = 0

func reload():
	_state = STATES.START
	velocity.x = 0
	position.x = _properties["position"]
	
	_reload_realtime_properties()



