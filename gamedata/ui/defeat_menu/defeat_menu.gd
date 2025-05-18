extends PanelContainer

@onready var level: Level = Global.game_controller.current_2d_scene
@onready var menu_button: Button = $"Menu Button"
@onready var restart_button: Button = $"Restart Button"

func _ready() -> void:
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
	# Pause the game
	get_tree().paused = true
	# Play SFX
	SoundManager.defeat.play()

func disable_buttons() -> void:
	menu_button.disabled = true
	restart_button.disabled = true

func _on_menu_button_pressed() -> void:
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	Global.game_controller.change_2d_scene("main_menu")

func _on_restart_button_pressed() -> void:
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	Global.game_controller.change_2d_scene(LevelData.get(level.technical_name)["name"])
