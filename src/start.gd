extends Control



func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_title("Lampotory - виртуальная лаборатория")
	#DisplayServer.window_set_min_size(Vector2i(900, 700))
	await get_tree().create_timer(1).timeout
	
	match OS.get_name():
		"Windows":
			get_tree().change_scene_to_file("res://src/menu/menu.tscn")
		"Android":
			get_tree().change_scene_to_file("res://src/android/menu/android_menu.tscn")
