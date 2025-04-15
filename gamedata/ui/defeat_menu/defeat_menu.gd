extends PanelContainer

@onready var menu_button: Button = $"Menu Button"
@onready var restart_button: Button = $"Restart Button"

func _ready():
	# Scale
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Animate
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	# Pause the game
	get_tree().paused = true
	# Play SFX
	SoundManager.defeat.play()

func disable_buttons():
	menu_button.disabled = true
	restart_button.disabled = true

func _on_menu_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://gamedata/scene/main_menu/main_menu.tscn")

func _on_restart_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	get_tree().reload_current_scene()
