class_name LampFileManager
extends Object

## Save file in file_path
static func pack_data(bodies_properties: Array[Dictionary], file: FileAccess):
	for body_properties in bodies_properties:
		var json = JSON.stringify(body_properties)
		file.store_line(json)

static func unpack_data(file: FileAccess) -> Array[Dictionary]:
	var bodies_properties: Array[Dictionary]
	while file.get_position() < file.get_length():
		var line = file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(line)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(),
					" in '", line, "' at line ", json.get_error_line())
			continue
		bodies_properties.push_back(json.get_data())
	return bodies_properties

static func save_file(bodies_node: Node2D, name: String):
	var file = FileAccess.open("res://saves/" + name + ".dlmp", FileAccess.WRITE)
	
	var save: Dictionary = {}
	for body in bodies_node.get_children():
		save[body.name] = body.get_all_properties()
	save["project_data"] = bodies_node.project_data
	file.store_var(save)
	
	file.close()


static func load_file(name: String):
	var file = FileAccess.open("res://saves/" + name + ".dlmp", FileAccess.READ)
	var save: Dictionary = file.get_var()
	var bodies_node = Bodies.new()
	
	for body_name in save:
		var body_properties = save[body_name]
		
		if body_name == "project_data":
			bodies_node.project_data = body_properties
			continue
		
		var body = ResourceLoader.load(body_properties["body_scene_path"]).instantiate()
		for property_name in body_properties:
			body.set(property_name, body_properties[property_name])
			for child in body.get_children():
				if child.name == property_name:
					for child_property_name in body_properties[property_name]:
						child.set(child_property_name, body_properties[property_name][child_property_name])
		body.loaded_properties = body_properties
		bodies_node.add_child(body)
	
	file.close()
	return bodies_node

