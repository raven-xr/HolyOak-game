extends "res://towers/platform/platform.gd"

@onready var level = $"../.."

func _on_child_entered_tree(node):
	if node.name == 'Tower':
		level.tower_count += 1

func _on_child_exiting_tree(node):
	if node.name == 'Tower':
		level.tower_count -= 1
