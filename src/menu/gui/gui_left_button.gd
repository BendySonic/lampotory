extends Button

@export var down_text: String
@export var up_icon: Texture2D

@export var icon_size: Vector2
@export var text_size: int

@onready var texture_rect := get_node(
			"MarginContainer/VBoxContainer/MarginContainer/TextureRect"
)
@onready var label: Label = get_node(
			"MarginContainer/VBoxContainer/MarginContainer2/Label"
)


func _ready():
	texture_rect.texture = up_icon
	label.text = down_text
	
	texture_rect.custom_minimum_size = icon_size
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = text_size
	label.label_settings.line_spacing = -10
	label.label_settings.font_color = Color(0.18, 0.18, 0.18)
