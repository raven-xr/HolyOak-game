extends PanelContainer

@onready var resume_button: Button = $"VBoxContainer/Resume Button"
@onready var settings_button: Button = $"VBoxContainer/Settings Button"
@onready var exit_button: Button = $"VBoxContainer/Exit Button"

func _ready() -> void:
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
	await tween.finished
	# Pause the game
	get_tree().paused = true

func disable_buttons() -> void:
	resume_button.disabled = true
	settings_button.disabled = true
	exit_button.disabled = true

func resume() -> void: # Is used by parent/siblings in the tree
	disable_buttons()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween.finished
	get_tree().paused = false
	queue_free()

func _on_resume_button_pressed() -> void:
	SoundManager.click.play()
	resume()

func _on_settings_button_pressed() -> void:
	SoundManager.click.play()
	Global.game_controller.change_gui_scene("settings", false, true)

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	disable_buttons()
	SoundManager.click.play()
	SoundManager.disable_music()
	Global.game_controller.change_2d_scene("main_menu")
