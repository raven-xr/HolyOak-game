extends CanvasLayer

# Nodes
@onready var panel_container = $PanelContainer
@onready var settings = $Settings

@onready var resume_button = $"PanelContainer/VBoxContainer/Resume Button"
@onready var settings_button = $"PanelContainer/VBoxContainer/Settings Button"
@onready var exit_button = $"PanelContainer/VBoxContainer/Exit Button"



# Common functions
func _ready():
	panel_container.scale = Vector2(UserSettings.gui_scale**2, UserSettings.gui_scale**2)
	# Animate
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0.2)
	await tween.finished
	# Pause the game
	get_tree().paused = true

func disable_buttons():
	resume_button.disabled = true
	settings_button.disabled = true
	exit_button.disabled = true

func resume(): # Is used by parent/siblings in the tree
	disable_buttons()
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 0.2)
	await tween.finished
	get_tree().paused = false
	queue_free()



# Resume Button's functions
func _on_resume_button_pressed():
	SoundManager.click.play()
	resume()



# Settings Button's functions
func _on_settings_button_pressed():
	SoundManager.click.play()
	settings.visible = true



# Exit Button's functions
func _on_exit_button_pressed():
	get_tree().paused = false
	disable_buttons()
	SoundManager.click.play()
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://gamedata/scene/main_menu/main_menu.tscn")
