################################
#author:BendySonic
#last_edited:BendySonic
#################################
#body_resource.gd
#script for "body_resource" Resource
#################################
class_name BodyResource extends Resource

#properties
var base:Dictionary = {
	"name": "Данные",
	"value_type": -1,
}
var body_id:Dictionary = {
	"name": "Номер",
	"info": "Идентификатор объекта в проекте",
	"value_1": 0,
	"vector": false,
	"value_type": 1,
	"can_change": false,
}
var widget_name:Dictionary = {
	"name": "Тип",
	"info": "Тип объекта (Например, 'Обычное тело', \t'Округлое тело')",
	"value_1": "Обычное тело",
	"vector": false,
	"value_type": 0,
	"can_change": false,
}
var position:Dictionary = {
	"name": "Положение",
	"info": "Позиция тела в метрах по координате x",
	"value_1": 0,
	"vector": false,
	"value_type": 1,
	"can_change": true,
}
var data:Dictionary = {
	"name": "Поведение",
	"value_type": -1,
}
var mass:Dictionary = {
	"name": "Масса",
	"info": "Масса тела в килограммах",
	"value_1": 1,
	"vector": false,
	"value_type": 1,
	"can_change": true,
}
var speed:Dictionary = {
	"name": "Скорость",
	"info": "Скорость тела в м/c (метр в секунду) \tна момент старта",
	"value_1": 0,
	"vector": false,
	"value_type": 1,
	"can_change": true,
}
var acceleration:Dictionary = {
	"name": "Ускорение",
	"info": "Ускорение тела в м/c(2) (метр в секунду \tв квадрате) на момент старта",
	"value_1": 0,
	"vector": false,
	"value_type": 1,
	"can_change": true,
}

#data
@export var body_name:String
@export var body_icon:Resource
