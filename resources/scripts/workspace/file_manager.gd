#################################
#author:BendySonic
#last_edited:BendySonic
#################################
#file_manager.gd
#script for file save/load
#################################
class_name file_manager extends Object

#public functions
static func save_file(content:String, file_name:String):
	var file = FileAccess.open("resources/saves/" + file_name, FileAccess.WRITE)
	file.store_string(content)
	file.close()

static func load_file(file_name:String) -> String:
	var file = FileAccess.open("resources/saves/" + file_name, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

