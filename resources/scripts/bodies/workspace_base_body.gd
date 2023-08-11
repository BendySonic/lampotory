#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#panel.gd
#script for base body in workspace
#################################
class_name WorkspaceBaseBody extends CharacterBody2D

#private variables
var body_name:String
@export var body_id:Dictionary = {
	"name": "Номер",
	"info": "Идентификатор объекта в проекте",
	"value": 0,
	"can_change": false,
}
@export var widget_name:Dictionary = {
	"name": "Тип",
	"info": "Тип объекта (Например, 'Обычное тело', \t'Округлое тело')",
	"value": "Обычное тело",
	"can_change": false,
}
@export var speed:Dictionary = {
	"name": "Скорость",
	"info": "Скорость тела в м/c (метр в секунду) \tна момент старта",
	"value": 0,
	"can_change": true,
}

#private functions
func _on_input_event(viewport, event, shape_idx):
	#Отправка сигнала после нажатия на объект для окна свойств
	if event is InputEventMouseButton:
		LampSignalManager.emit_signal("body_input", body_name)

#public functions
func construct(body_name_arg:String):
	body_name = body_name_arg
