extends CanvasLayer
# Class for window app


@onready var menu_scene := preload("res://src/menu/menu.tscn")
@onready var main_scene :=  preload("res://src/main/main.tscn")

@onready var sub_viewport := get_node("Border/SubViewportContainer/SubViewport")

# Private functions
func _init():
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(Vector2i(1100, 720))
	DisplayServer.window_set_position((screen_size / 2) - Vector2i(550, 360))
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)

func _ready():
	change_scene_to(menu_scene, null)

func free_scenes():
	for scene in sub_viewport.get_children():
		scene.queue_free()

func add_scene(scene: PackedScene, arg: Variant):
	var new_scene = scene.instantiate()
	new_scene.init(change_scene_to, arg)
	sub_viewport.add_child(new_scene)

# Public functions
func change_scene_to(scene: PackedScene, arg: Variant):
	free_scenes()
	add_scene(scene, arg)
