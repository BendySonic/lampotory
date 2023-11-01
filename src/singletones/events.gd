extends Node

# GUI
signal item_pressed(index: int, item_scene: PackedScene, item_count: int)
signal workspace_pressed()
signal play_toggled(button_pressed: bool)
signal reload_pressed()
# BodyBase.
signal data_changed(new_data, property_id: String, id: int)

