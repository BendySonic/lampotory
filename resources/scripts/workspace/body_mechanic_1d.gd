class_name BodyMechanic1D
extends BodyBase

# -----------------------------------------------------------------------------
const MY_PROPERTIES = ["mass", "speed", "acceleration"]

@onready var form = get_node("Polygon2D")
@onready var collision = get_node("CollisionPolygon2D")

# -----------------------------------------------------------------------------
func _ready():
	super()
	_set_form()
	# Set values
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
	_set_values()


func play():
	velocity.x = _properties["speed"]


func pause():
	velocity = Vector2(0, 0)


func reload():
	pause()
	position.x = _properties["position"]


func _set_form():
	var pva:PackedVector2Array = [Vector2(-16, -16), Vector2(16, -16),
			Vector2(16, 16), Vector2(-16, 16)]
	var pva2:PackedVector2Array = [Vector2(-17, -17), Vector2(17, -17),
			Vector2(17, 17), Vector2(-17, 17)]
	form.polygon = pva
	collision.polygon = pva


func _set_values():
	_properties["id"] = _data.id
	_properties["position"] = position.x
