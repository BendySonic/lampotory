class_name BodyBaseMechanic1D
extends BodyBase
# Base class for ALL "mechanic_1d" bodies

var kinematic_collision: KinematicCollision2D

# Speed and path
func _physics_process(delta):
	if _state == STATES.PLAY:
		# Speed
		_data.realtime_properties["speed"] += (
				_data.realtime_properties["acceleration"] * delta
		)
		# Moving
		velocity.x = _data.realtime_properties["speed"]
		kinematic_collision = move_and_collide(velocity * delta)
		# Collision recovery
		if not kinematic_collision == null:
			var target = kinematic_collision.get_collider()
			if target.position.x > position.x:
				position.x -= 2
				target.position.x += 2
			else:
				position.x += 2
				target.position.x -= 2
		# Path
		_data.realtime_properties["path"] += absf(velocity.x) * delta


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



