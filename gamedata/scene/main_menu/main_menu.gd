extends Node2D

@export var level_1: PackedScene
@export var level_2: PackedScene
@export var level_3: PackedScene

@export var star_scene: PackedScene

@onready var game_name: Label = $GameName
@onready var explorer: PanelContainer = $Explorer
@onready var v_box_container: VBoxContainer = $Explorer/VBoxContainer
@onready var levels: Control = $Levels
@onready var grid_container: GridContainer = $Levels/GridContainer
@onready var levels_back_button: TextureButton = $"Levels/Back Button"
@onready var credits_back_button: TextureButton = $"Credits/Back Button"
@onready var credits: Control = $Credits

func _ready() -> void:
	# Scale GUI
	var gui_scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	game_name.scale = gui_scale
	explorer.scale = gui_scale
	levels.scale = gui_scale
	credits.scale = gui_scale
	# Play music
	SoundManager.music_main.play()
	# Unblock levels
	for i in range(1, grid_container.get_child_count()):
		var button = grid_container.get_child(i)
		# Get buttons and the levels they redirect to and check if they are completed
		var required_level_name: StringName = grid_container.get_child(i - 1).level_technical_name
		if UserData.progress[required_level_name]["is_completed"]:
			button.disabled = false
			# If level is available, show its number
			button.get_node("Label").visible = true
	# Giving stars to levels
	for button in grid_container.get_children():
		var level_name: StringName = button.level_technical_name
		for i in range(UserData.progress[level_name]["stars"]):
			var star = star_scene.instantiate()
			star.position = Vector2(17.0 + 32.0 * i, 104.0)
			button.add_child(star)

func animate_transition() -> void:
	# Disable buttons
	for button in v_box_container.get_children():
		button.disabled = true
	for button in grid_container.get_children():
		button.visible = false
	levels_back_button.disabled = true
	# Animate
	var tween_1 = create_tween()
	tween_1.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.1)
	var tween_2 = create_tween()
	tween_2.tween_property(SoundManager.music_main, "volume_db", -100, 0.2)

func _on_play_button_pressed() -> void:
	SoundManager.click.play()
	explorer.visible = false
	levels.visible = true
	var tween = create_tween()
	tween.tween_property(levels, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)

func _on_credits_button_pressed() -> void:
	SoundManager.click.play()
	explorer.visible = false
	credits.visible = true
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)

func _on_settings_button_pressed() -> void:
	SoundManager.click.play()
	Global.game_controller.change_gui_scene("settings")

func _on_exit_button_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	get_tree().quit()

func _on_levels_back_button_pressed() -> void:
	SoundManager.click.play()
	levels.visible = false
	levels.modulate = Color(1.0, 1.0, 1.0, 0.0)
	explorer.visible = true
	explorer.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(explorer, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)

func _on_level_1_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	Global.game_controller.change_2d_scene("level_1")

func _on_level_2_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	Global.game_controller.change_2d_scene("level_2")

func _on_level_3_pressed() -> void:
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	Global.game_controller.change_2d_scene("level_3")

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
	tween.tween_property(credits, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
	await tween.finished
	credits.visible = false
