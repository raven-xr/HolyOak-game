extends CanvasLayer

@onready var panel_container = $PanelContainer
@onready var resume_button = $"PanelContainer/VBoxContainer/Resume Button"
@onready var settings_button = $"PanelContainer/VBoxContainer/Settings Button"
@onready var quit_button = $"PanelContainer/VBoxContainer/Quit Button"

func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0.2)
	get_tree().paused = true

func _on_resume_button_pressed():
	SoundManager.click.play()
	resume()

func _on_settings_button_pressed():
	disable_buttons()
	SoundManager.click.play()
	# Open settings

func _on_quit_button_pressed():
	get_tree().paused = false
	disable_buttons()
	SoundManager.click.play()
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func disable_buttons():
	resume_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true

func resume():
	get_tree().paused = false
	disable_buttons()
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 0.2)
	tween.connect("finished", queue_free)
