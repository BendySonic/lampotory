class_name UICursorWidget extends Node2D


# Private variables
var follow_mouse:bool = false


# Public methods
func _process(delta):
	position = get_global_mouse_position()

func set_icon(body_icon:Resource):
	$Sprite2D.texture = body_icon


# Public methods
func construct(data:BodyResource):
	set_icon(data.body_icon)

