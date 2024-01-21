class_name DynamometerBody
extends NormalBody

var place_holder_start_position: Vector2
@onready var place_holder = get_node("PlaceHolder")

func prepare_body():
	super()
	if is_loaded:
		place_holder.position = place_holder_start_position

func _physics_process(delta):
	place_holder_start_position = place_holder.position


#func _input(event):
#	super(event)
#	if event is InputEventMouseButton:
#		if event.button_index == 2:
#			if event.is_pressed():
#				print(arrow_value)
