extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var menu_button = $"PanelContainer/Menu Button"
@onready var restart_button = $"PanelContainer/Restart Button"

func _ready():
	get_tree().paused = true
	SoundManager.defeat.play()

func _on_restart_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	change_level()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	change_level()
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)

func change_level():
	menu_button.disabled = true
	restart_button.disabled = true
