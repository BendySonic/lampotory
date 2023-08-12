class_name MechanicBody extends WorkspaceBaseBody


@onready var form = get_node("Polygon2D")
@onready var collision = get_node("CollisionPolygon2D")

func _ready():
	set_signals()
	
	var pva:PackedVector2Array = [Vector2(-16, -16), Vector2(16, -16),
			Vector2(16, 16), Vector2(-16, 16)]
	form.polygon = pva
	collision.polygon = pva
	
	res_properties = [res.base, res.body_id, res.widget_name,
			res.position, res.size, res.data, res.speed]


#func _process(delta):
	#print(res.speed["value"])
