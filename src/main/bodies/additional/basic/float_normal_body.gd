class_name FloatNormalBody
extends NormalBody

func prepare_body():
	set_start_position()
	
	linear_velocity = Vector2(0, 0)
	collision_layer = 5
	collision_mask = 0
	gravity_scale = 0
