#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#panel.gd
#script for base body in workspace
#################################
class_name WorkspaceBaseBody extends CharacterBody2D

#private variables
@export var res:BodyResource

#private functions
func _on_input_event(viewport, event, shape_idx):
	#Отправка сигнала после нажатия на объект для окна свойств
	if event is InputEventMouseButton:
		LampSignalManager.emit_signal("body_input", res)

#public functions
func construct(res_arg:BodyResource):
	res = res_arg
