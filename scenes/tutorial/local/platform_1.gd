extends "res://towers/platform/platform.gd"

@onready var level = $"../.."

func _on_local_build_texture_button_pressed():
	level.emit_signal("player_built_tower")
	build_texture_button.disconnect("pressed", Callable(self, "_on_local_build_texture_button_pressed"))

func _on_local_upgrade_texture_button_pressed():
	level.emit_signal("player_upgraded_tower")
	upgrade_texture_button.disconnect("pressed", Callable(self, "_on_local_upgrade_texture_button_pressed"))

func _on_remove_texture_button_mouse_entered():
	remove_texture_button.disabled = true

func _on_child_entered_tree(node):
	if node.name == "Tower":
		level.emit_signal("player_built_tower")

func _on_tutorial_player_ended_tutorial():
	disconnect("child_entered_tree", Callable(self, "_on_child_entered_tree"))
	remove_texture_button.disconnect("mouse_entered", Callable(self, "_on_remove_texture_button_mouse_entered"))
