extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var menu_button = $"PanelContainer/Menu Button"
@onready var next_button = $"PanelContainer/Next Button"

func _ready():
	get_tree().paused = true
	SoundManager.victory.play()

func _on_next_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	change_level()
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)

func _on_menu_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	change_level()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func change_level():
	menu_button.disabled = true
	next_button.disabled = true
