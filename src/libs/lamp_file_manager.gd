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
	
	var save_data: Dictionary = {}
	for body in bodies_node.get_children():
		save_data[body.name] = body.save_body()
	save_data["project_data"] = bodies_node.project_data
	file.store_var(save_data)
	
	file.close()


static func load_file(name: String):
	var file = FileAccess.open("res://saves/" + name + ".dlmp", FileAccess.READ)
	var save_data: Dictionary = file.get_var()
	var bodies_node = Bodies.new()
	
	for body_name in save_data:
		var body_data = save_data[body_name]
		
		if body_name == "project_data":
			bodies_node.project_data = body_data
			continue
		
		var body: NormalBody
		for node_name in body_data:
			var node_data = body_data[node_name]
			if node_data.has("body_scene_path"):
				body = ResourceLoader.load(node_data["body_scene_path"]).instantiate()
		body.load_body(body_data)
		bodies_node.add_child(body)
	
	file.close()
	return bodies_node

