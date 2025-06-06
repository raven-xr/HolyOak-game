extends NodeGUI

@onready var level: Level = Global.game_controller.current_2d_scene
@onready var menu_button: Button = $"PanelContainer/Menu Button"
@onready var next_button: Button = $"PanelContainer/Next Button"

func _ready() -> void:
	get_tree().paused = true
	SoundManager.victory.play()

func disable_buttons() -> void:
	menu_button.disabled = true
	next_button.disabled = true

func _on_menu_button_pressed() -> void:
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	Global.game_controller.change_2d_scene("main_menu")

func _on_next_button_pressed() -> void:
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	Global.game_controller.change_2d_scene(level.next_level)
