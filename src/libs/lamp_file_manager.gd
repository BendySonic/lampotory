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
	#var file = FileAccess.open(file_path, FileAccess.WRITE)
	#for body in bodies_node.get_children():
	#	file.store_var(body.duplicate(), true)
	#pack_data(bodies_properties, file)
	#file.close()
	var scene = PackedScene.new()
	
	for body in bodies_node.get_children():
		body.owner = bodies_node
		for node in body.get_children():
			node.owner = body
	
	var result = scene.pack(bodies_node)
	if result == OK:
		var error = ResourceSaver.save(scene, "res://saves/" + name + ".tscn", 64)  # Or "user://..."
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")


static func load_file(name: String):
	#var file = FileAccess.open(file_path, FileAccess.READ)
	#var bodies: Array[RigidBody2D]
	#while file.get_position() < file.get_length():
	#	var body = file.get_var(true)
	#	bodies.push_back(body)
	#file.close()
	var result = ResourceLoader.load("res://saves/" + name + ".tscn", "", 0)
	return result

