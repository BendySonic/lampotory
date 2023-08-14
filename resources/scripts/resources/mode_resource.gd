class_name ModeResource extends Resource

enum MODES {MECHANIC_1D, MECHANIC_2D}

@export var body_resource_path:String
@export var body_path:String

@export var body_names:PackedStringArray

var body_scenes:Dictionary
var resources:Dictionary

var mode:int = MODES.MECHANIC_1D

var base_text:Dictionary = {
	"id": "base_text",
	"name": "Данные",
	"value_type": -1,
}
var id:Dictionary = {
	"id": "id",
	"name": "Номер",
	"info": "Идентификатор объекта в проекте",
	"vector": false,
	"value_type": 1,
	"can_change": false,
}
var name:Dictionary = {
	"id": "name",
	"name": "Тип",
	"info": "Тип объекта (Например, 'Обычное тело', \t'Округлое тело')",
	"vector": false,
	"value_type": 0,
	"can_change": false,
}
var position:Dictionary = {
	"id": "position",
	"name": "Положение",
	"info": "Позиция тела в метрах по координате x",
	"vector": false,
	"value_type": 1,
	"can_change": true,
}
var data_text:Dictionary = {
	"id": "data_text",
	"name": "Поведение",
	"value_type": -1,
}
var mass:Dictionary = {
	"id": "mass",
	"name": "Масса",
	"info": "Масса тела в килограммах",
	"vector": false,
	"value_type": 1,
	"can_change": true,
}
var speed:Dictionary = {
	"id": "speed",
	"name": "Скорость",
	"info": "Скорость тела в м/c (метр в секунду) \tна момент старта",
	"vector": false,
	"value_type": 1,
	"can_change": true,
}
var acceleration:Dictionary = {
	"id": "acceleration",
	"name": "Ускорение",
	"info": "Ускорение тела в м/c(2) (метр в секунду \tв квадрате) на момент старта",
	"vector": false,
	"value_type": 1,
	"can_change": true,
}

var properties:Array[Dictionary] = [
		base_text, id, name, position,
		data_text, mass, speed, acceleration
]
