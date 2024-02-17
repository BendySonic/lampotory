class_name PulleyPoint
extends RigidBody2D

# Pulley point data
var is_held: bool
var releative_drag_position: Vector2
# Physics data
var v0: Vector2
var result_force: Vector2
var rope_vector: Vector2

var rope_force_length: float

@onready var pin_joint := get_parent().get_node("PinJoint2D")


func _physics_process(delta):
	# Physics
	var v:Vector2 = linear_velocity
	var acceleration: Vector2 = (v - v0) / delta
	result_force = mass * acceleration
	
	rope_vector = position - pin_joint.position
	
	rope_force_length = result_force.length() * cos(result_force.angle_to(rope_vector))
	print(result_force, rope_force_length)
	# Hold
	if is_held:
		linear_velocity = (
				(Global.cursor.global_position
				- global_position) * 20
		)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				if not is_held:
					is_held = true
					releative_drag_position = to_local(Global.cursor.global_position)
					pin_joint.node_b = ""

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.is_pressed():
				if is_held:
					is_held = false
					pin_joint.node_b = self.get_path()
					pin_joint.length = position.length()
