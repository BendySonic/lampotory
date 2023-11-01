class_name BodyBaseMechanic1D
extends BodyBase
# Base class for ALL "mechanic" bodies

var _kinematic_collision: KinematicCollision2D
var _collision_test_margin := Vector2(0.1, 0)
var _ready_to_collide := true

# Moving
# TODO - Develop player speed system
func _physics_process(delta):
	if _state == STATES.PLAY:
		# Speed
		if _data.realtime_properties.has("acceleration"):
			_data.realtime_properties["speed"] += (
					_data.realtime_properties["acceleration"]
					* get_speed.call() * delta
			)	
		# Moving
		#velocity.x = _data.realtime_properties["speed"]
		#move_and_collide(velocity * get_speed.call() * delta, false, 0.1)
		_kinematic_collision = move_and_collide(_collision_test_margin, true)
		# Path
		#_data.realtime_properties["path"] += (
		#	absf(velocity.x) * get_speed.call() * delta
		#)


# Body player
func play():
	_state = STATES.PLAY
	#velocity.x = _data.realtime_properties["speed"]

func pause():
	_state = STATES.PAUSE
	#velocity.x = 0

func reload():
	_state = STATES.START
	#velocity.x = 0
	
	position.x = _data.properties["position"]
	_ready_to_collide = true
	_reload_realtime_properties()



