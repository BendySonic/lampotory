class_name GUICursorWidget
extends Node2D


var _data:BodyResource

@onready var icon = get_node("Sprite2D")


func _physics_process(_delta):
	position = get_global_mouse_position()

func _set_icon(body_icon:Resource):
	icon.texture = body_icon


# Public methods
func construct(data_arg: BodyResource):
	_data = data_arg
	_set_icon(_data.body_icon)

func get_data():
	return _data
