extends Node


static func has_abc(text:String):
	var regex = RegEx.new()
	regex.compile("\\D$")
	var regex2 = RegEx.new()
	regex2.compile("(\\-$)|(\\.$)")
	if (regex.search(text)) and !(regex2.search(text)):
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
