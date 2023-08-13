class_name MechanicBody extends WorkspaceBaseBody


@onready var form = get_node("Polygon2D")
@onready var collision = get_node("CollisionPolygon2D")
@onready var area_collision = get_node("Area2D/CollisionPolygon2D2")

func _ready():
	set_signals()
	
	var pva:PackedVector2Array = [Vector2(-16, -16), Vector2(16, -16),
			Vector2(16, 16), Vector2(-16, 16)]
	var pva2:PackedVector2Array = [Vector2(-17, -17), Vector2(17, -17),
			Vector2(17, 17), Vector2(-17, 17)]
	form.polygon = pva
	collision.polygon = pva
	
	res_properties = [res.base, res.body_id, res.widget_name,
			res.position, res.size, res.data, res.speed]


#func _process(delta):
	#print(res.speed["value"])


func _on_area_2d_body_entered(body):
	print("enter2")
