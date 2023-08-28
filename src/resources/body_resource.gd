class_name BodyResource
extends Resource

# Body data.
@export var body_name: String
@export var body_icon: Resource
# Item list data
@export var item_name: String
@export var item_tooltip: String
var item_selected := false
# Body identifier
var id: int
# Properties
var properties: Dictionary
var realtime_properties: Dictionary
