#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#workspace.gd
#script for libraries and static functions
#################################
extends Node


static func has_abc(text:String):
	var regex = RegEx.new()
	regex.compile("\\D")
	if (regex.search(text)):
		return true
	else:
		return false


static func has_123(text:String):
	var regex = RegEx.new()
	regex.compile("\\d")
	if (regex.search(text)):
		return true
	else:
		return false
