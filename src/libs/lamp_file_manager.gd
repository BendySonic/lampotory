class_name LampFileManager
extends Object

## Save file in file_path
static func pack_data(bodies_properties: Array[Dictionary], file: FileAccess):
	for body_properties in bodies_properties:
		var json_line = JSON.stringify(body_properties)
		file.store_line(json_line)

static func unpack_data(file: FileAccess) -> Array[Dictionary]:
	var bodies_properties: Array[Dictionary]
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var json_line = JSON.new()
		#json_line.parse_string(line)
		json_line.parse(line)
		bodies_properties.push_back(json_line.get_data())
	return bodies_properties

static func save_file(file_path: String, bodies_properties: Array[Dictionary]):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	pack_data(bodies_properties, file)
	file.close()

static func load_file(file_path:String) -> Array[Dictionary]:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var bodies_properties = unpack_data(file)
	file.close()
	return bodies_properties

