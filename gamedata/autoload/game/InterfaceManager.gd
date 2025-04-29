extends CanvasLayer

@export var victory_menu: PackedScene
@export var defeat_menu: PackedScene

## Adds an interface element by its StringName
func add(node_name: StringName = "") -> void:
	add_child(get(node_name).instantiate())
