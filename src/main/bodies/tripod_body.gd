class_name TripodBody
extends NormalBody


func init(properties_arg: Dictionary, edit_properties_arg: Dictionary,
		body_scene_arg: PackedScene, cursor_arg: GUICursor):
	super(properties_arg, edit_properties_arg, body_scene_arg, cursor_arg)
	self.global_position = Vector2(cursor_arg.global_position.x, 440)

func hold_body():
	super()
	collision_layer = 2
	collision_mask = 2
	lock_rotation = true
	set_deferred("freeze", false)

func unhold_body():
	super()
	collision_layer = 5
	collision_mask = 1
	set_deferred("freeze", true)
