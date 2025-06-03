extends NodeGUI

@onready var level: Level = Global.game_controller.current_2d_scene
@onready var menu_button: Button = $"PanelContainer/Menu Button"
@onready var restart_button: Button = $"PanelContainer/Restart Button"

func _ready() -> void:
	get_tree().paused = true
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
