extends Control



func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_title("Lampotory - виртуальная лаборатория")
	await get_tree().create_timer(1).timeout
	
	match OS.get_name():
		"Android":
			get_tree().change_scene_to_file("res://src/android/menu/android_menu.tscn")
		_:
			get_tree().change_scene_to_file("res://src/menu/menu.tscn")
