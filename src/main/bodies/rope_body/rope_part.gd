extends RigidBody2D

var last_rope_part = null

func _physics_process(delta):
	queue_redraw()

func _draw():
	if not last_rope_part == null:
		draw_line(to_local(last_rope_part.global_position), to_local(global_position), Color.LIME_GREEN, 6.0)
