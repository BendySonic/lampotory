extends Node

# Workspace signals:
# GridWidget.
signal widget_input(event:InputEventMouse, cursor_widget:UICursorWidget)

# BodyBase.
signal body_input(properties:Dictionary)
signal data_changed(new_data, property_id, id)

# UI.
signal play_pressed()
signal reload_pressed()
