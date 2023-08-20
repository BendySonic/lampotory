class_name ModeResource
extends Resource

enum MODES { MECHANIC_1D, MECHANIC_2D }

@export var body_resource_path:String
@export var body_scene_path:String
@export var body_names:PackedStringArray
@export var mode:int

var body_scenes:Dictionary
var body_resources:Dictionary

@export var properties:Dictionary = {
	"data_text": "Данные",
	"id": 0.0,
	"type": "Тело",
	"position": 0.0,
	"behavior_text": "Поведение",
	"mass": 0.0,
	"speed": 0.0,
	"acceleration": 0.0,
	"path": 0.0,
}

@export var local_ru:Dictionary = {
	"id": "Номер",
	"type": "Тип",
	"position": "Позиция",
	"mass": "Масса",
	"speed": "Скорость",
	"acceleration": "Ускорение",
	"path": "Путь",
}
