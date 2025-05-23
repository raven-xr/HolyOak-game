extends Node2D

@export var star_scene: PackedScene

@onready var game_name: Label = $"Game Name"
@onready var explorer: PanelContainer = $Explorer
@onready var v_box_container: VBoxContainer = $Explorer/VBoxContainer
@onready var levels: Control = $Levels
@onready var grid_container: GridContainer = $Levels/GridContainer
@onready var back_button: TextureButton = $"Levels/Back Button"
@onready var credits: Control = $Credits
@onready var settings: Control = $Settings

func _ready() -> void:
	# Scale GUI
	var gui_scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	game_name.scale = gui_scale
	explorer.scale = gui_scale
	levels.scale = gui_scale
	credits.scale = gui_scale
	settings.scale = gui_scale
	# Load save
	if FileAccess.file_exists(UserData.SAVE_PATH):
		var save = FileAccess.open(UserData.SAVE_PATH, FileAccess.READ)
		UserData.progress = save.get_var()
	# Play music
	SoundManager.music_main.play()
	# Unblock levels
	for i in range(1, grid_container.get_child_count()):
		var button = grid_container.get_child(i)
		var required_level_name = grid_container.get_child(i - 1).name
		if UserData.progress[required_level_name]["is_completed"]:
			button.disabled = false
			# If level is available, show its number
			button.get_node("Label").visible = true
	# Giving stars to levels
	for button in grid_container.get_children():
		var level_name = button.name
		for i in range(UserData.progress[level_name]["stars"]):
			var star = star_scene.instantiate()
			star.position = Vector2(13 + 23*i, 74)
			button.add_child(star)
	# Set modulate
	levels.modulate = Color(1, 1, 1, 0)
	credits.modulate = Color(1, 1, 1, 0)

func animate_transition() -> void:
	# Disable buttons
	for button in v_box_container.get_children():
		button.disabled = true
	for button in grid_container.get_children():
		button.visible = false
	back_button.disabled = true
	# Animate
	var tween_1 = create_tween()
	tween_1.tween_property(self, "modulate", Color(0, 0, 0, 1), 0.1)
	var tween_2 = create_tween()
	tween_2.tween_property(SoundManager.music_main, "volume_db", -100, 0.2)

func _on_play_button_pressed() -> void:
	SoundManager.click.play()
	explorer.visible = false
	explorer.modulate = Color(1, 1, 1, 0)
	levels.visible = true
	var tween = create_tween()
	tween.tween_property(levels, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_credits_button_pressed() -> void:
	SoundManager.click.play()
	explorer.visible = false
	credits.visible = true
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_settings_button_pressed() -> void:
	SoundManager.click.play()
	settings.visible = true

func _on_exit_button_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	get_tree().quit()

func _on_levels_back_button_pressed() -> void:
	SoundManager.click.play()
	levels.visible = false
	levels.modulate = Color(1, 1, 1, 0)
	explorer.visible = true
	var tween = create_tween()
	tween.tween_property(explorer, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_level_1_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://gamedata/scene/level_1/level_1.tscn")

func _on_level_2_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://gamedata/scene/level_2/level_2.tscn")

func _on_level_3_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://gamedata/scene/level_3/level_3.tscn")

func _on_level_4_pressed() -> void:
	SoundManager.click.play()

func _on_level_5_pressed() -> void:
	SoundManager.click.play()

func _on_level_6_pressed() -> void:
	SoundManager.click.play()

func _on_credits_back_button_pressed() -> void:
	SoundManager.click.play()
	explorer.visible = true
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	credits.visible = false
