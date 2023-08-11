#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#widget_cursor.gd
#script for lighter object while hold grid_widget
#################################
class_name CursorWidget extends Node2D


#private variables
var object_name:String
var object_icon:Resource
var follow_mouse:bool = false


#private functions
func _process(delta):
	position = get_global_mouse_position()

func set_icon(body_icon:Resource):
	$Sprite2D.texture = body_icon


#public functions
func construct(body_name:String, body_icon:Resource):
	object_name = body_name
	object_icon = body_icon
	set_icon(body_icon)

