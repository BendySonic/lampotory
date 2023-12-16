class_name TripodBody
extends NormalBody

@onready var spring_joint: DampedSpringJoint2D = get_node("SpringJoint")
@onready var cargo_body: RigidBody2D = get_node("CargoBody")


func init(item_data_arg: ItemResource, position_arg: Vector2, cursor_arg: GUICursor):
	super(item_data_arg, position_arg, cursor_arg)
	self.global_position = Vector2(position_arg.x, 440)

func _physics_process(_delta):
	# Hold
	if _is_state(States.HOLD) and body_defined:
		var direction = Vector2(
			(get_global_mouse_position().x - global_position.x) * 25, 
			0
		)
		physics_state.set_linear_velocity(direction)
		# Can unhold
		can_unhold = not area.has_overlapping_bodies()
	# Sync collision layers and masks
	cargo_body.collision_layer = collision_layer
	cargo_body.collision_mask = collision_mask
	# Redraw rope
	queue_redraw()

func _draw():
	# Draw rope
	draw_line(
			spring_joint.position + Vector2(0, 10), 
			cargo_body.position,
			Color.WHITE, 7.0
	)

func hold_body():
	super()
	set_deferred("freeze", false)
	cargo_body.set_deferred("freeze", true)

func unhold_body():
	super()
	set_deferred("freeze", true)
	cargo_body.set_deferred("freeze", false)
