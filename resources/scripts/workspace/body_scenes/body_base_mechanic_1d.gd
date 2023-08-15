class_name BodyBaseMechanic1D
extends BodyBase


func play():
	_state = STATES.PLAY
	velocity.x = _properties["speed"]


func pause():
	_state = STATES.PAUSE
	velocity = Vector2(0, 0)


func reload():
	_state = STATES.START
	pause()
	position.x = _properties["position"]
