extends CanvasLayer

@onready var click = $SFX/Click
@onready var resume_button = $"PanelContainer/VBoxContainer/Resume Button"
@onready var settings_button = $"PanelContainer/VBoxContainer/Settings Button"
@onready var quit_button = $"PanelContainer/VBoxContainer/Quit Button"

func _ready():
	get_tree().paused = true

func _on_resume_button_pressed():
	get_tree().paused = false
	disable_buttons()
	click.play()
	await click.finished
	queue_free()

func _on_settings_button_pressed():
	disable_buttons()
	click.play()
	await click.finished
	# Open settings

func _on_quit_button_pressed():
	get_tree().paused = false
	disable_buttons()
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func disable_buttons():
	resume_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true
