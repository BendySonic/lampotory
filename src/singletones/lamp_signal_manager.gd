extends Node

# GUI.
# GridWidget.
signal widget_input(event: InputEventMouse, cursor_widget: GUICursorWidget)

# BodyBase.
signal body_pressed(properties: Dictionary, body_id: int)
signal data_changed(new_data, property_id: String, id: int)

# Player.
signal play_toggled(button_pressed: bool)
signal reload_pressed()


