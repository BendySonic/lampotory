class_name GUICursorWidget
extends Node2D

# -----------------------------------------------------------------------------
var data:BodyResource

@onready var icon = get_node("Sprite2D")

# -----------------------------------------------------------------------------
func _physics_process(_delta):
	position = get_global_mouse_position()


func _set_icon(body_icon:Resource):
	icon.texture = body_icon


# Public methods
func construct(data_arg: BodyResource):
	data = data_arg
	_set_icon(data.body_icon)

