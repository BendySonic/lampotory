class_name PointMechanic1D
extends BodyBaseMechanic1D
# Point1D for 1D Movement without collision and mass


func _ready():
	super()
	_extra_base_properties = ["speed", "acceleration"]
	_extra_base_realtime_properties = ["path"]
	# Create properties and add to "_properties" (BaseBody class)
	_reload_properties()
	_reload_realtime_properties()
	_set_values()



