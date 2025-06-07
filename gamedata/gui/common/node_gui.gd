extends Control
## Don't overwrite the "_on_ready", "_input" and "close" functions if this isn't a necessary
class_name NodeGUI

@export var can_be_closed: bool = true

func _on_ready() -> void:
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.15)

func _input(_event: InputEvent) -> void:
	# All GUI-scenes have to be NodeGUIs or at least have the "can_be_closed" property
	if Input.is_action_just_pressed("ui_cancel") and can_be_closed:
		SoundManager.click.play()
		close()

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
