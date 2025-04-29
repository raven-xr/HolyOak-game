extends PanelContainer

@onready var level: Level = get_tree().get_current_scene()

@onready var menu_button: Button = $"Menu Button"
@onready var next_button: Button = $"Next Button"

func _ready() -> void:
	# Scale
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
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
	get_tree().change_scene_to_file("res://gamedata/scene/main_menu/main_menu.tscn")
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween.finished
	queue_free()

func _on_next_button_pressed() -> void:
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2)
	await tween.finished
	queue_free()
