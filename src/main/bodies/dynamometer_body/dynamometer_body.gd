class_name DynamometerBody
extends NormalBody

@export var length_coeff: float = 8
@export var width_coeff: float = 15
@export var skew_coeff: float = 3.5
@export var ring_count: float = 4
var arrow_value: float = 0

var place_holder_start_position: Vector2

@onready var place_holder = get_node("PlaceHolder")

func _ready():
	super()
	if is_loaded:
		place_holder.position = place_holder_start_position

func _physics_process(delta):
	place_holder_start_position = place_holder.position


#func _input(event):
#	super(event)
#	if event is InputEventMouseButton:
#		if event.button_index == 2:
#			if event.is_pressed():
#				print(arrow_value)
