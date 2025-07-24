extends NodeGUI

@onready var resume_button: Button = $"PanelContainer/VBoxContainer/Resume Button"
@onready var settings_button: Button = $"PanelContainer/VBoxContainer/Settings Button"
@onready var exit_button: Button = $"PanelContainer/VBoxContainer/Exit Button"

func _ready() -> void:
	get_tree().paused = true

func disable_buttons() -> void:
	resume_button.disabled = true
	settings_button.disabled = true
	exit_button.disabled = true

func close() -> void:
	disable_buttons()
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
	get_tree().paused = false
	disable_buttons()
	SoundManager.click.play()
	SoundManager.disable_music()
	Global.game_controller.change_2d_scene("main_menu")
