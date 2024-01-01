class_name TripodBody
extends NormalBody


func init(item_data_arg: ItemResource, position_arg: Vector2, cursor_arg: GUICursor):
	super(item_data_arg, position_arg, cursor_arg)
	self.global_position = Vector2(position_arg.x, 440)

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
