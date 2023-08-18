class_name BodyMechanic1D
extends BodyBaseMechanic1D
# Classic Body1D for 1D movement with mass, speed, acceleration

# -----------------------------------------------------------------------------
@onready var form = get_node("Polygon2D")
@onready var outline = get_node("Select")
@onready var collision = get_node("CollisionPolygon2D")

# -----------------------------------------------------------------------------
func _ready():
	super()
	_extra_properties = ["mass", "speed", "acceleration"]
	# Create properties and add to "_properties" (BaseBody class)
	_add_properties()
	_set_values()
	_set_form()


func _set_values():
	_properties["id"] = _data.id
	_properties["name"] = _data.widget_name
	_properties["position"] = position.x


func _set_form():
	var pva:PackedVector2Array = [Vector2(-16, -16), Vector2(16, -16),
			Vector2(16, 16), Vector2(-16, 16)]
	var pva2:PackedVector2Array = [Vector2(-20, -20), Vector2(20, -20),
			Vector2(20, 20), Vector2(-20, 20)]
	outline.polygon = pva2
	form.polygon = pva
	collision.polygon = pva
