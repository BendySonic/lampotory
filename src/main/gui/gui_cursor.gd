class_name GUICursor
extends Node2D


var item_data: ItemResource:
	get: return item_data

@onready var icon := get_node("Sprite2D") as Sprite2D


func init(item_data_arg: ItemResource):
	self.item_data = item_data_arg

func _ready():
	self.icon.texture = item_data.item_icon

func _physics_process(_delta):
	position = get_global_mouse_position()
