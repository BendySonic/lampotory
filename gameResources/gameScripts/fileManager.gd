class_name fileManager extends Node

#public
static func save_file(content:String, fileName:String):
	var file = FileAccess.open("resources/gameSaves/" + fileName, FileAccess.WRITE)
	file.store_string(content)
	file.close()

static func load_file(fileName:String) -> String:
	var file = FileAccess.open("resources/gameSaves/" + fileName, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

