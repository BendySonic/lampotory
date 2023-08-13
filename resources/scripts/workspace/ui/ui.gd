class_name workspace_ui extends Control


#private functions


func _on_play_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal("play")


func _on_reload_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal("reload")
