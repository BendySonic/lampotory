class_name PointMechanic1D
extends BodyBaseMechanic1D

# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
func _ready():
	super()
	_extra_properties = ["speed", "acceleration"]
	# Create properties and add to "_properties" (BaseBody class)
	_add_properties()
	_set_values()


func _set_values():
	_properties["id"] = _data.id
	_properties["name"] = _data.widget_name
	_properties["position"] = position.x
