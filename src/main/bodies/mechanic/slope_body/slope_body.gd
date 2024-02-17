class_name SlopeBody
extends StaticNormalBody

var width: float:
	set = set_width
var height: float:
	set = set_height
var friction: float:
	set = set_friction

@onready var shape := get_node("CollisionShape2D") as CollisionShape2D
@onready var mesh := get_node("Visuals/MeshInstance2D") as Polygon2D


func prepare_body():
	super()
	center_of_mass = Vector2(width / 4, -height / 4)

func set_width(value):
	width = value
	mesh.polygon[2].x = abs(value)
	shape.shape.points[2].x = abs(value)
	center_of_mass = Vector2(width / 4, -height / 4)

func set_height(value):
	height = value
	mesh.polygon[1].y = -abs(value)
	shape.shape.points[1].y = -abs(value)
	center_of_mass = Vector2(width / 4, -height / 4)

func set_friction(value):
	friction = value
	physics_material_override.friction = value
