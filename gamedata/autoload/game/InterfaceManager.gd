extends Node

## Adds an interface element by its name
## If there is no such a node, it prints an error
func add(node_name: StringName = "") -> void:
	if get(node_name):
		add_child(get(node_name).instantiate())
	else:
		print("ERROR: the \"%s\" node doesn't exist or isn't defined in the interface manager!" % String(node_name))
