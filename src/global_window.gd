extends CanvasLayer
# Class for window app


# Children nodes
@onready var sub_viewport: SubViewport = get_node(
		"Border/SubViewportContainer/SubViewport"
)

# Scene connects
@onready var menu_scene := preload("res://src/menu/menu.tscn")


# Private functions
func _ready():
	sub_viewport.handle_input_locally = true
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
