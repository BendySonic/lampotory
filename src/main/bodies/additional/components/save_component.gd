class_name SaveComponent
extends Node

@export var save_properties_list: Dictionary
@export var save_nodes: Array[Node]

func save_data():
	var save_data: Dictionary
	
	for node in save_nodes:
		node.prepare_save()
		var node_path = get_path_to(node)
		
		save_data[node_path] = Dictionary()
		var node_data = save_data[node_path]
		
		for property in node.get_property_list():
			var property_name = property["name"]
			
			if save_properties_list[node_path].has(property_name):
				var value = node.get(property_name)
				
				node_data[property_name] = (
						value.duplicate() if value is Dictionary else value
				)
	print(save_data)
	return save_data

func load_data(save_data: Dictionary, body: NormalBody):
	if save_data.is_empty():
		return
	for node_path in save_data:
		var node = get_node(node_path)
		var node_data = save_data[node_path]
		for property_name in node_data:
			node.set(property_name, node_data[property_name])
