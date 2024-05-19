extends Control

@onready var animation: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	animation.play("rotate")
	prepare()

func prepare():
	await get_tree().create_timer(0.1).timeout
	var main: PackedScene
	main = await ResourceLoader.load("res://src/main/main.tscn")
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_packed(main)
