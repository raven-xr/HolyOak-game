extends NodeGUI

@onready var resume_button: Button = $"PanelContainer/VBoxContainer/Resume Button"
@onready var settings_button: Button = $"PanelContainer/VBoxContainer/Settings Button"
@onready var exit_button: Button = $"PanelContainer/VBoxContainer/Exit Button"

func _ready() -> void:
	get_tree().paused = true

func set_buttons_disabled(disabled: bool = true) -> void:
	resume_button.disabled = disabled
	settings_button.disabled = disabled
	exit_button.disabled = disabled

func close() -> void:
	set_buttons_disabled()
	get_tree().paused = false
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await tween.finished
	Global.game_controller.current_2d_scene.menu_button.disabled = false # Enables the menu button of the level
	queue_free()

func _on_resume_button_pressed() -> void:
	SoundManager.click.play()
	close()

func _on_settings_button_pressed() -> void:
	SoundManager.click.play()
	Global.game_controller.change_gui_scene("settings", false, true)

func _on_exit_button_pressed() -> void:
	set_buttons_disabled()
	SoundManager.click.play()
	Global.game_controller.change_gui_scene("confirmation")
	Global.game_controller.current_gui_scene.set_text("Вы уверены? Весь прогресс будет безвозвратно утерян!")
	Global.game_controller.current_gui_scene.connect("confirmed", Callable(self, "_on_exit_confirmed"))
	Global.game_controller.current_gui_scene.connect("canceled", Callable(self, "_on_exit_canceled"))

func _on_exit_confirmed() -> void:
	get_tree().paused = false
	SoundManager.disable_music()
	Global.game_controller.change_2d_scene("main_menu")

func _on_exit_canceled() -> void:
	set_buttons_disabled(false)
