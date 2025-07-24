extends Control
class_name NodeGUI

func _on_ready() -> void:
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.15)

func close() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	await tween.finished
	# Change the value of the "current_gui_scene" variable if this NodeGUI is the current_gui_scene
	if Global.game_controller.current_gui_scene == self:
		if Global.game_controller.gui.get_child_count() == 1:
			Global.game_controller.current_gui_scene = null
		else:
			Global.game_controller.current_gui_scene = Global.game_controller.gui.get_child(-2)
	queue_free()
