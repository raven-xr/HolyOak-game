extends CanvasLayer

@onready var settings = $Settings
@onready var panel_container = $PanelContainer

@onready var resume_button = $"PanelContainer/VBoxContainer/Resume Button"
@onready var settings_button = $"PanelContainer/VBoxContainer/Settings Button"
@onready var exit_button = $"PanelContainer/VBoxContainer/Exit Button"



func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0.2)
	await tween.finished
	get_tree().paused = true

func _on_resume_button_pressed():
	SoundManager.click.play()
	resume()

func _on_settings_button_pressed():
	SoundManager.click.play()
	settings.visible = true

func _on_quit_button_pressed():
	get_tree().paused = false
	disable_buttons()
	SoundManager.click.play()
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func disable_buttons():
	resume_button.disabled = true
	settings_button.disabled = true
	exit_button.disabled = true

func resume():
	disable_buttons()
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 0.2)
	await tween.finished
	get_tree().paused = false
	queue_free()
