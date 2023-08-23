class_name BodyBaseMechanic1D
extends BodyBase
# Base class for ALL "mechanic_1d" bodies


var kinematic_collision: KinematicCollision2D


# Moving
func _physics_process(delta):
	if _state == STATES.PLAY:
		# Speed
		if _data.realtime_properties.has("acceleration"):
			_data.realtime_properties["speed"] += (
					_data.realtime_properties["acceleration"]
					* get_speed.call() * delta
			)	
		# Moving
		velocity.x = _data.realtime_properties["speed"]
		kinematic_collision = move_and_collide(
				velocity * get_speed.call()* delta, false, 0.1
		)
		# Path
		_data.realtime_properties["path"] += (
			absf(velocity.x) * get_speed.call() * delta
		)


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



