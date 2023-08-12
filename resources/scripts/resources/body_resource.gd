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
var base:Dictionary = {
	"name": "Данные",
	"value_type": -1,
}
var body_id:Dictionary = {
	"name": "Номер",
	"info": "Идентификатор объекта в проекте",
	"value_x": 0,
	"vector": false,
	"value_type": 1,
	"can_change": false,
}
var widget_name:Dictionary = {
	"name": "Тип",
	"info": "Тип объекта (Например, 'Обычное тело', \t'Округлое тело')",
	"value_x": "Обычное тело",
	"vector": false,
	"value_type": 0,
	"can_change": false,
}
var position:Dictionary = {
	"name": "Положение",
	"info": "Позиция тела в метрах по координатам \tx - по горизонтале, y - по вертикале",
	"value_x": 0,
	"value_y": 0,
	"vector": true,
	"value_type": 1,
	"can_change": true,
}
var size:Dictionary = {
	"name": "Размер",
	"info": "Размер тела в метрах\tx - по горизонтале, y - по вертикале",
	"value_x": 0,
	"value_y": 0,
	"vector": true,
	"value_type": 1,
	"can_change": true,
}
var data:Dictionary = {
	"name": "Поведение",
	"value_type": -1,
}
var speed:Dictionary = {
	"name": "Скорость",
	"info": "Скорость тела в м/c (метр в секунду) \tна момент старта \tx - по горизонтале, y - по вертикале",
	"value_x": 0,
	"value_y": 0,
	"vector": true,
	"value_type": 1,
	"can_change": true,
}


#data
@export var body_name:String
@export var body_icon:Resource
