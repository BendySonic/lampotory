class_name LampLib
extends Object


static func has_abc(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("\\D$")
	var regex2 = RegEx.new()
	regex2.compile("(\\-$)|(\\.$)")
	if (regex.search(text)) and !(regex2.search(text)):
		return true
	else:
		return false


static func has_123(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("\\d")
	if (regex.search(text)):
		return true
	else:
		return false


static func has_child(node: Node) -> bool:
	return bool(node.get_child_count())
