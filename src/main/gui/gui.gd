extends CanvasLayer
# Class for GUI

# -----------------------------------------------------------------------------
# Mouse input handle (Based on input signals)
# click = get signals result
# release = check signals in "_input"
var _workspace_area_input: bool = false # Signal result
var _body_input: bool = false # Signal result
# World
var create_body: Callable
var select_body: Callable
var deselect_bodies: Callable
var get_has_selected_body: Callable
var get_bodies: Callable
var get_bodies_count: Callable
# Main
var get_mode_data: Callable

@onready var grid_widget_scene = preload("res://src/main/gui/" +
		"gui_grid_widget.tscn")
@onready var cursor_widget_scene = preload("res://src/main/gui/" +
		"gui_cursor_widget.tscn")
@onready var property_scene = preload("res://src/main/gui/" +
		"gui_property.tscn")

@onready var grid_control = get_node("ObjectsWindow/VBoxContainer/" +
		"Body/VBox/Margin/Grid")
@onready var properties_control = get_node("PropertiesWindow/" +
		"VBoxContainer/Margin/Properties")
@onready var realtime_properties_control = get_node("HUD/Other/" +
		"MarginContainer/VBoxContainer/Info")
@onready var workspace_area = get_node("HUD/Other/MarginContainer")
@onready var select = get_node("SelectedObject")


# -----------------------------------------------------------------------------
func _ready():
	_create_grid_widgets()
	LampSignalManager.widget_input.connect(_on_grid_widget_input)
	LampSignalManager.body_input.connect(_on_body_input)

func _process(_delta):
	# Grid size managment
	if grid_control.size.x >= 180 and grid_control.size.x < 280:
		grid_control.columns = 2
	elif grid_control.size.x >= 280:
		grid_control.columns = 3
	# Realtime properties managment (REALTIME_PROPERTIES_CONTROL)
	if get_has_selected_body.call():
		for body in get_bodies.call():
			if body._selected:
				realtime_properties_control.text = (
						"Скорость: " + LampLib.trfr(str(
							body.get_realtime_property("speed")), 2)
						+ "\nУскорение: " + LampLib.trfr(str(
							body.get_realtime_property("acceleration")), 2)
						+ "\nПройденный путь: " + LampLib.trfr(str(
							body.get_realtime_property("path")), 2)
					)

# Check mouse input signals and clear properties/select (on release)
func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			# Check signals
			if _workspace_area_input and not _body_input:
				deselect_bodies.call()
				for child in properties_control.get_children():
					child.queue_free()
				realtime_properties_control.text = (
						"Скорость: 0\nУскорение: 0\nПройденный путь: 0"
				)
			# Restart signal results
			_workspace_area_input = false
			_body_input = false


# Signals
# GRID_WIDGET is element of body list in UI
func _on_grid_widget_input(event: InputEventMouse, grid_widget: GUIGridWidget):
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
			
			# Cursor delete.
			select.remove_child(cursor_widget)
			cursor_widget.queue_free()
			
			# Body create.
			create_body.call(body_data)

func _on_workspace_area_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# Return
			_workspace_area_input = true

# Show body properties in PROPERTIES_CONTROL
func _on_body_input(body_properties: Dictionary, body_id: int):
	var local_ru = get_mode_data.call().local_ru
	
	select_body.call(body_id)
	for child in properties_control.get_children():
		child.queue_free()
	
	for body_property in body_properties:
		var property_instance = property_scene.instantiate()
		properties_control.add_child(property_instance)
		property_instance.construct(body_properties, body_property, local_ru)
	# Return
	_body_input = true

func _on_play_gui_input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			LampSignalManager.emit_signal("play_pressed")

func _on_reload_gui_input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			LampSignalManager.emit_signal("reload_pressed")


# Grid widget is element of body list in UI
# Every mode show own grid widgets
func _create_grid_widgets():
	for widget_name in get_mode_data.call().body_names:
		var grid_widget = grid_widget_scene.instantiate()
		grid_control.add_child(grid_widget)
		grid_widget.construct(get_mode_data.call().body_resources[widget_name])
