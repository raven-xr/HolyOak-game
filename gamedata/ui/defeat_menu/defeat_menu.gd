extends PanelContainer

@onready var menu_button: Button = $"Menu Button"
@onready var restart_button: Button = $"Restart Button"

func _ready() -> void:
	# Scaling
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
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
	get_tree().change_scene_to_file("res://gamedata/scene/main_menu/main_menu.tscn")
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween.finished
	queue_free()

func _on_restart_button_pressed() -> void:
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	get_tree().reload_current_scene()
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween.finished
	queue_free()
