extends Button

@export var down_text: String
@export var up_icon: Texture2D

@onready var texture_rect := get_node(
			"MarginContainer/VBoxContainer/MarginContainer/TextureRect"
)
@onready var label := get_node(
			"MarginContainer/VBoxContainer/MarginContainer2/Label"
)


func _ready():
	texture_rect.texture = up_icon
	label.text = down_text
