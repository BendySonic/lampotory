class_name LampFileManager
extends Object

## Save file in file_path
static func save_file(bodies_node: Node2D, name: String):
	var file = FileAccess.open("saves/" + name + ".dlmp", FileAccess.WRITE)
	
	var save_data: Dictionary = {}
	for body in bodies_node.get_children():
		save_data[body.name] = body.save_body()
	save_data["project_data"] = Global.project_data
	file.store_var(save_data)
	
	file.close()


static func load_file(name: String):
	var file = FileAccess.open("saves/" + name + ".dlmp", FileAccess.READ)
	var save_data: Dictionary = file.get_var()
	var bodies_node = Node2D.new()
	
	for body_name in save_data:
		var body_data = save_data[body_name]
		
		if body_name == "project_data":
			Global.project_data = body_data
			continue
		
		var body: NormalBody
		for node_name in body_data:
			var node_data = body_data[node_name]
			if node_data.has("body_scene_path"):
				body = ResourceLoader.load(node_data["body_scene_path"]).instantiate()
		body.name = body_name
		body.load_body(body_data)
		bodies_node.add_child(body)
	
	file.close()
	return bodies_node

