extends Node

# GUI GridWidget.
signal widget_input(event: InputEventMouse, cursor_widget: GUICursorWidget)

# BodyBase.
signal body_input(properties: Dictionary, body_id: int)
signal data_changed(new_data, property_id: String, id: int)

# UI.
signal play_pressed()
signal reload_pressed()

