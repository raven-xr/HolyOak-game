extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var menu_button = $"PanelContainer/Menu Button"
@onready var next_button = $"PanelContainer/Next Button"
@onready var panel_container = $PanelContainer

func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0.2)
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
