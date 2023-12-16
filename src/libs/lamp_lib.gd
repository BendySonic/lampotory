class_name LampLib
extends Object


# String methods
# Has letters and etc.
static func has_abc(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("\\D$")
	var regex2 = RegEx.new()
	regex2.compile("(\\-$)|(\\.$)")
	if (regex.search(text)) and !(regex2.search(text)):
		return true
	else:
		return false

# Has numbers and etc.
static func has_123(text: String) -> bool:
	var regex = RegEx.new()
	regex.compile("\\d")
	if (regex.search(text)):
		return true
	else:
		return false


# trim_fraction
# trfr("1.245", 1) -> 1.2
# trfr("1.245", 2) -> 1.24
static func trfr(text: String, count: int) -> String:
	var regex_dot = RegEx.new()
	if not text.find(".") == -1:
		var regex = RegEx.new()
		regex.compile("\\d{1,}.\\d{" + str(count) + "}")
		return regex.search(text + "00").get_string()
	else:
		return text


# Node methods
static func has_child(node: Node) -> bool:
	return bool(node.get_child_count())


static func error(text: String):
	print("Error: ", text)
