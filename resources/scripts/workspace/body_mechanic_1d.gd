class_name BodyMechanic1D extends BodyBase


var my_properties:Array[String] = ["mass", "speed", "acceleration"]

@onready var form = get_node("Polygon2D")
@onready var collision = get_node("CollisionPolygon2D")

func _ready():
	super()
	set_form()
	
	# Set values
	print(properties)
	for dictionary in mode_data.properties:
		if (my_properties.has(dictionary["id"])
			or base_properties.has(dictionary["id"])):
			if dictionary["value_type"] != -1:
				if dictionary["vector"]:
					properties[dictionary["id"]] = Vector2(0, 0)
				else:
					properties[dictionary["id"]] = 0
			else:
				properties[dictionary["id"]] = " "
	

func set_form():
	var pva:PackedVector2Array = [Vector2(-16, -16), Vector2(16, -16),
			Vector2(16, 16), Vector2(-16, 16)]
	var pva2:PackedVector2Array = [Vector2(-17, -17), Vector2(17, -17),
			Vector2(17, 17), Vector2(-17, 17)]
	form.polygon = pva
	collision.polygon = pva


func _on_area_2d_body_entered(body):
	print("enter2")


func play():
	velocity.x = properties["speed"]


func pause():
	velocity = Vector2(0, 0)


func reload():
	pause()
	position.x = properties["speed"]
