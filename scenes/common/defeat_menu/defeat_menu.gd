extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var panel_container = $PanelContainer
@onready var menu_button = $"PanelContainer/Menu Button"
@onready var restart_button = $"PanelContainer/Restart Button"

func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0.2)
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
