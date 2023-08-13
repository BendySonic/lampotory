#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#panel.gd
#script for base body in workspace
#################################
class_name WorkspaceBaseBody extends CharacterBody2D

#private variables
enum STATES {START, PLAY, PAUSE}
var state = STATES.START

var res:BodyResource
var res_properties:Array[Dictionary]

#private functions
func _process(delta):
	move_and_collide(velocity * delta)


func set_signals():
	LampSignalManager.data_changed.connect(on_data_change)


func _on_input_event(viewport, event, shape_idx):
	#Отправка сигнала после нажатия на объект для окна свойств
	if event is InputEventMouseButton:
		if !event.is_pressed():
			LampSignalManager.emit_signal("body_input", res_properties, res.body_id["value_x"])


func on_data_change(new_data, property_name, value_type, id):
	if res.body_id["value_x"] == id:
		for property in res_properties:
			if property["name"] == property_name:
				property[value_type] = new_data
				reload()
	else:
		return 0

#public functions
func construct(res_arg:BodyResource):
	res = res_arg

#Проигрывание движения согласно скоростти
func play():
	velocity = Vector2(res.speed["value_x"], res.speed["value_y"])

#Пауза движения
func pause():
	velocity = Vector2(0, 0)

#Перезагрузка характеристик
func reload():
	pause()
	position = Vector2(res.position["value_x"], res.position["value_y"])
