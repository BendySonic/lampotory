## Resource for body (workspace)

################################
#author:BendySonic
#last_edited:BendySonic
#################################
#body_resource.gd
#script for "body_resource" Resource
#################################
class_name BodyResource extends Resource

#properties
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
var properties = [body_id, widget_name, speed]

#data
@export var body_name:String
@export var body_icon:Resource
