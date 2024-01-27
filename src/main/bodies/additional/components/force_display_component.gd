class_name ForceDisplayComponent
extends Node2D

@export var main_body: NormalBody
@export var disabled: bool = false

var v0: Vector2
var v: Vector2

var a: Vector2
var force: Vector2

var gravity_force: Vector2

func _physics_process(delta):
	if not disabled:
		gravity_force = main_body.mass * Vector2(0, 980) / 10
		queue_redraw()

func _draw():
	draw_line(main_body.position, main_body.position + gravity_force, Color.RED, 5)
