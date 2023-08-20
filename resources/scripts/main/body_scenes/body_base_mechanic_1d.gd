class_name BodyBaseMechanic1D
extends BodyBase
## Base class for ALL "mechanic_1d" bodies

var kinematic_collision: KinematicCollision2D

# Speed and path
func _physics_process(delta):
	if _state == STATES.PLAY:
		# Speed
		_data.realtime_properties["speed"] += (
				_data.realtime_properties["acceleration"] * delta
		)
		# Path
		_data.realtime_properties["path"] += absf(velocity.x) * delta
		# Moving
		velocity.x = _data.realtime_properties["speed"]
		kinematic_collision = move_and_collide(velocity * delta)


# Body player
func play():
	_state = STATES.PLAY
	velocity.x = _data.realtime_properties["speed"]

func pause():
	_state = STATES.PAUSE
	velocity.x = 0

func reload():
	_state = STATES.START
	velocity.x = 0
	position.x = _data.properties["position"]
	
	_reload_realtime_properties()



