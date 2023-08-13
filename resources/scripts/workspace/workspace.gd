#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#workspace.gd
#script for laboratory workspace
#################################
class_name Workspace extends Node2D

#private variables
#Сцены рабочей облатси
const SCENES_PATH = "res://resources/scenes/workspace/ui/"
const SCENES = ["ui", "grid_widget", "cursor_widget", "property"]

#Элементы интерфейса
const GRID_PATH = ("VBox/HBox2/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/PanelBodies/VBoxContainer/Margin/VBox/Margin/Grid")
const PANEL_PATH = "VBox/HBox2/PanelContainer"
const PROPERTIES_PATH = ("VBox/HBox2/PanelContainer/HBoxContainer/MarginContainer/VBoxContainer/PanelProperties/VBoxContainer/Margin/VBox")

#Настройки режима рабочей области
const MODE_RESOURCE_PATH = "res://resources/scenes/workspace/mode_resources/"
const MODE_NAMES = ["one_mechanic", "two_mechanic"]

var mode_num:int = 0
var mode_resource:ModeResource
var scenes:Dictionary

var choosen_res:BodyResource
var playing:bool = false
var body_count:int = 0

#Удобные обращаения к нодам из загруженных сцен рабочей области
var ui:Node
var grid:Node
var properties:Node
var panel:Node

#Удобное обращение к слоям рабочей области
@onready var layer_ui:CanvasLayer = $LayerUI
@onready var layer_selected:CanvasLayer = $LayerSelected
@onready var layer_workspace:Node2D = $LayerWorkspace


#private functions
func _ready():
	set_workspace_mode()
	
	load_body_scenes()
	load_body_resources()
	load_workspace_scenes()
	set_workspace_scenes()
	
	set_signals()


func set_signals():
	LampSignalManager.widget_input.connect(on_grid_widget_gui_input)
	LampSignalManager.body_input.connect(on_body_gui_input)
	LampSignalManager.play.connect(on_play)
	LampSignalManager.reload.connect(on_reload)


func set_workspace_mode():
	mode_resource = load(MODE_RESOURCE_PATH + MODE_NAMES[mode_num] + ".tres").duplicate()


func load_body_scenes():
	for body_name in mode_resource.body_names:
		mode_resource.body_scenes[body_name] = (
			load(mode_resource.body_path + body_name + ".tscn"))


func load_body_resources():
	for body_name in mode_resource.body_names:
		mode_resource.resources[body_name] = (
			load(mode_resource.body_resource_path + body_name + ".tres"))


func load_workspace_scenes():
	for scene_name in SCENES:
		scenes[scene_name] = load(SCENES_PATH + scene_name + ".tscn")

#Установка побочных сцен в рабочей области
func set_workspace_scenes():
	#ui
	ui = scenes["ui"].instantiate()
	layer_ui.add_child(ui)
	
	#grid, panel, properties
	grid = ui.get_node(GRID_PATH)
	panel = ui.get_node(PANEL_PATH)
	properties = ui.get_node(PROPERTIES_PATH)
	
	#GridWidget's
	for widget_name in mode_resource.body_scenes:
		var widget = scenes["grid_widget"].instantiate()
		grid.add_child(widget)
		widget.construct(mode_resource.resources[widget_name])


func set_grid():
	pass

#При взаимодействии с элементом таблицы объектов
func on_grid_widget_gui_input(event:InputEventMouse, grid_widget:GridWidget):
	if event is InputEventMouseButton:
		#GridWidget нажат
		if event.is_pressed():
			choosen_res = grid_widget.res.duplicate()
			
			var cursor_widget = scenes["cursor_widget"].instantiate()
			layer_selected.add_child(cursor_widget)
			cursor_widget.construct(choosen_res)
				
		#GridWidget отпущен / создание тела
		if not event.is_pressed():
			body_count += 1
			choosen_res.body_id["value_1"] = body_count
			#Тело
			var body = mode_resource.body_scenes[choosen_res.body_name].instantiate()
			body.name = str(body_count)
			body.position = Vector2(get_global_mouse_position().x, 0)
			choosen_res.position["value_1"] = body.position.x
			body.construct(choosen_res)
			layer_workspace.add_child(body)
			#Курсор
			var cursor_widget = layer_selected.get_child(0)
			layer_selected.remove_child(cursor_widget)
			cursor_widget.queue_free()

#Открытие свойств объекта в окне при нажатии на объект
func on_body_gui_input(res_properties:Array[Dictionary], id:int):
	#Очистка поля свойств
	if bool(properties.get_child_count()):
		for child in properties.get_children():
			child.queue_free()
	#Обновление поля свойств (Каждое свойство = сцена)
	for property in res_properties:
		var property_scene = scenes["property"].instantiate()
		properties.add_child(property_scene)
		#Заглавия разделов
		if property["value_type"] == -1:
			property_scene.title_panel.visible = true
			property_scene.title.text = property["name"]
			continue
		#Обычные свойства / передача типа свойства
		property_scene.property_panel.visible = true
		property_scene.property.text = property["name"]
		property_scene.type = property["value_type"]
		property_scene.body_id = id
		
		if property["vector"]:
			property_scene.down_container.visible = true
			
			property_scene.x_edit.visible = true
			property_scene.x_label.visible = true
			property_scene.x_edit.text = str(property["value_x"])
				
			property_scene.y_edit.visible = true
			property_scene.y_label.visible = true
			property_scene.y_edit.text = str(property["value_y"])
		else:
			if property["can_change"]:
				property_scene.x_edit.visible = true
				property_scene.x_edit.text = str(property["value_1"])
			else:
				property_scene.x_value_label.visible = true
				property_scene.x_value_label.text = str(property["value_1"])

#Воспроизведение и остановка сцены
func on_play():
	print("play")
	playing = !playing
	for body in layer_workspace.get_children():
		if playing:
			body.play()
		else:
			body.pause()


func on_reload():
	playing = false
	for body in layer_workspace.get_children():
		body.reload()
