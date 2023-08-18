class_name UI
extends Control
## Class for UI managment

# -----------------------------------------------------------------------------
# Mouse input handle (Based on input signals)
# click = get signals result
# release = check signals in "_input"
var workspace_area_input: bool = false # Signal result
var body_input: bool = false # Signal result
# Main workspace node
var workspace: Node

@onready var grid_widget_scene = preload("res://resources/scenes/workspace/" +
		"ui/ui_grid_widget.tscn")
@onready var cursor_widget_scene = preload("res://resources/scenes/workspace/" +
		"ui/ui_cursor_widget.tscn")
@onready var property_scene = preload("res://resources/scenes/workspace/ui/" +
		"ui_property.tscn")

@onready var grid_control = get_node("VBox/HBox2/VBoxContainer2/" +
		"PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/" +
		"PanelBodies/VBoxContainer/Margin/VBox/Margin/Grid")
@onready var panel_control = get_node("VBox/HBox2/VBoxContainer2")
@onready var properties_control = get_node("VBox/HBox2/VBoxContainer2/" +
		"PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/" +
		"PanelProperties/VBoxContainer/Margin/Properties")
@onready var realtime_properties_control = get_node("VBox/HBox2/" +
		"MarginContainer/VBoxContainer/Info")
@onready var workspace_area = get_node("VBox/HBox2/MarginContainer")
@onready var select = get_node("Select")

# -----------------------------------------------------------------------------
func _ready():
	LampLib.trfr("0", 1)
	LampSignalManager.widget_input.connect(_on_grid_widget_input)
	LampSignalManager.body_input.connect(_on_body_input)


func _process(_delta):
	# Grid size managment
	if grid_control.size.x >= 180 and grid_control.size.x < 280:
		grid_control.columns = 2
	elif grid_control.size.x >= 280:
		grid_control.columns = 3
	# Realtime properties managment (REALTIME_PROPERTIES_CONTROL)
	if workspace.objects.has_selected_object:
		for body in workspace.objects.get_children():
			if body._selected:
				realtime_properties_control.text = (
						"Скорость: " + LampLib.trfr(str(
							body.get_realtime_properties()["speed"]), 2)
						+ "\nУскорение: " + LampLib.trfr(str(
							body.get_realtime_properties()["acceleration"]), 2)
						+ "\nПройденный путь: " + LampLib.trfr(str(
							body.path), 2)
				)


# Check mouse input signals and clear properties/select (on release)
func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			# Check signals
			if workspace_area_input and not body_input:
				workspace.objects.deselect_bodies()
				if LampLib.has_child(properties_control):
					for child in properties_control.get_children():
						child.queue_free()
				realtime_properties_control.text = (
						"Скорость: 0\nУскорение: 0\nПройденный путь: 0"
				)
			# Restart signal results
			workspace_area_input = false
			body_input = false



# GRID_WIDGET is element of body list in UI
func _on_grid_widget_input(event: InputEventMouse, grid_widget: UIGridWidget):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# Body data is data container for new body
			var body_data: BodyResource = grid_widget.data.duplicate()
			
			# Cursor create.
			var cursor_widget = cursor_widget_scene.instantiate()
			select.add_child(cursor_widget)
			cursor_widget.construct(body_data)
		
		elif not event.is_pressed():
			var cursor_widget = select.get_child(0)
			var body_data: BodyResource = cursor_widget.data
			
			workspace.objects.count += 1
			body_data.id = workspace.objects.count
			
			# Cursor delete.
			select.remove_child(cursor_widget)
			cursor_widget.queue_free()
			
			# Body create.
			workspace.objects.create_body(body_data)


func _on_workspace_area_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# Return
			workspace_area_input = true


# Show body properties in PROPERTIES_CONTROL
func _on_body_input(body_properties: Dictionary, body_id: int):
	workspace.objects.select_body(body_id)
	if LampLib.has_child(properties_control):
		for child in properties_control.get_children():
			child.queue_free()
	# Check for property template (Is property legit?)
	for property in body_properties:
		var base_property
		for dictionary in workspace.mode_data.properties:
			if dictionary["id"] == property:
				base_property = dictionary
		if base_property == null:
			continue
		
		var property_instance = property_scene.instantiate()
		properties_control.add_child(property_instance)
		property_instance.construct(base_property, body_properties,
				property)
	# Return
	body_input = true


func _on_play_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal("play_pressed")


func _on_reload_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			LampSignalManager.emit_signal("reload_pressed")


# Grid widget is element of body list in UI
# Every mode show own grid widgets
func create_grid_widgets(mode_data: ModeResource):
	for widget_name in mode_data.body_names:
		var grid_widget = grid_widget_scene.instantiate()
		grid_control.add_child(grid_widget)
		grid_widget.construct(mode_data.body_resources[widget_name])
