class_name PointMechanic1D
extends BodyBaseMechanic1D

# -----------------------------------------------------------------------------
const MY_PROPERTIES = ["speed", "acceleration"]

# -----------------------------------------------------------------------------
func _ready():
	super()
	# Create properties
	for dictionary in mode_data.properties:
		if (
			MY_PROPERTIES.has(dictionary["id"])
			or BASE_PROPERTIES.has(dictionary["id"])
		):
			if dictionary["value_type"] != -1:
				if dictionary["vector"]:
					_properties[dictionary["id"]] = Vector2(0, 0)
				else:
					_properties[dictionary["id"]] = 0
			else:
				_properties[dictionary["id"]] = " "
	# Set properties values / Set object form
	_set_values()


func _set_values():
	_properties["id"] = _data.id
	_properties["name"] = _data.widget_name
	_properties["position"] = position.x
