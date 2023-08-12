#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#lamp_file_manager.gd
#script for helpful functions
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
