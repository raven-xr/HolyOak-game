extends "res://units/platform/platform.gd"

@onready var level = $"../.."

func _on_local_touch_screen_button_pressed():
	level.emit_signal("player_opened_platform")
	touch_screen_button.disconnect("pressed", Callable(self, "_on_local_touch_screen_button_pressed"))

func _on_local_build_button_pressed():
	level.emit_signal("player_built_tower")
	build_button.disconnect("pressed", Callable(self, "_on_local_build_button_pressed"))

func _on_local_upgrade_button_pressed():
	level.emit_signal("player_upgraded_tower")
	upgrade_button.disconnect("pressed", Callable(self, "_on_local_upgrade_button_pressed"))

func _on_local_tower_stats_button_pressed():
	level.emit_signal("player_checked_stats")
	tower_stats_button.disconnect("pressed", Callable(self, "_on_local_tower_stats_button_pressed"))

func _on_local_remove_button_mouse_entered():
	remove_button.disabled = true

func _on_local_tower_stats_button_mouse_entered():
	tower_stats_button.disabled = true

func _on_tutorial_player_ended_tutorial():
	# Enable the remove button if the menu is opened
	if menu.visible:
		remove_button.disabled = false
	remove_button.disconnect("mouse_entered", Callable(self, "_on_local_remove_button_mouse_entered"))
