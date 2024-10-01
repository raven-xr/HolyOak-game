extends "res://towers/platform/platform.gd"

@onready var level = $"../.."
@onready var touch_screen_button = $TouchScreenButton

func _on_local_build_texture_button_pressed():
	level.emit_signal("player_built_tower")
	build_texture_button.disconnect("pressed", Callable(self, "_on_local_build_texture_button_pressed"))

func _on_local_upgrade_texture_button_pressed():
	level.emit_signal("player_upgraded_tower")
	upgrade_texture_button.disconnect("pressed", Callable(self, "_on_local_upgrade_texture_button_pressed"))

func _on_local_touch_screen_button_pressed():
	level.emit_signal("player_opened_platform")
	touch_screen_button.disconnect("pressed", Callable(self, "_on_local_touch_screen_button_pressed"))

func _on_local_tower_stats_texture_button_pressed():
	level.emit_signal("player_checked_stats")
	tower_stats_texture_button.disconnect("pressed", Callable(self, "_on_local_tower_stats_texture_button_pressed"))

func _on_remove_texture_button_mouse_entered():
	remove_texture_button.disabled = true

func _on_tower_stats_texture_button_mouse_entered():
	tower_stats_texture_button.disabled = true

func _on_tutorial_player_ended_tutorial():
	remove_texture_button.disconnect("mouse_entered", Callable(self, "_on_remove_texture_button_mouse_entered"))
