class_name UICursorWidget
extends Node2D

# -----------------------------------------------------------------------------
func _process(delta):
	position = get_global_mouse_position()

func _set_icon(body_icon:Resource):
	$Sprite2D.texture = body_icon


# Public methods
func construct(data: BodyResource):
	_set_icon(data.body_icon)

