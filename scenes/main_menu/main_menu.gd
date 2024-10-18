extends Control

# Exporting variables
@export var star_scene: PackedScene

# Explorer's variables
@onready var explorer = $Explorer
@onready var v_box_container = $Explorer/VBoxContainer
@onready var play_button = $"Explorer/VBoxContainer/Play Button"
@onready var settings_button = $"Explorer/VBoxContainer/Settings Button"
@onready var exit_button = $"Explorer/VBoxContainer/Exit Button"

# Levels' varibales
@onready var levels = $Levels
@onready var grid_container = $Levels/GridContainer

# Credits' variables
@onready var credits = $Credits

### Common functions
func _ready():
	# Load save
	if FileAccess.file_exists(UserData.SAVE_PATH):
		var save = FileAccess.open(UserData.SAVE_PATH, FileAccess.READ)
		UserData.level_data = save.get_var()
	# Play music
	SoundManager.music_main.play()
	# Unblock levels
	for i in range(1, grid_container.get_child_count()):
		var button = grid_container.get_child(i)
		var required_level_name = grid_container.get_child(i - 1).name
		if UserData.level_data[required_level_name]["is_completed"]:
			button.disabled = false
			# If level is available, show its number
			button.get_node("Label").visible = true
	# Giving stars to levels
	for button in grid_container.get_children():
		var level_name = button.name
		for i in range(0, UserData.level_data[level_name]["stars"]):
			var star = star_scene.instantiate()
			star.position = Vector2(13 + 23*i, 74)
			button.add_child(star)
	# Set modulates
	levels.modulate = Color(1, 1, 1, 0)
	credits.modulate = Color(1, 1, 1, 0)
	
func animate_transition():
	for button in v_box_container.get_children():
		button.disabled = true
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 0.1)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_main, "volume_db", -100, 0.2)



### Explorer's functions
func _on_play_button_pressed():
	SoundManager.click.play()
	explorer.visible = false
	explorer.modulate = Color(1, 1, 1, 0)
	levels.visible = true
	var tween = create_tween()
	tween.tween_property(levels, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_credits_button_pressed():
	SoundManager.click.play()
	explorer.visible = false
	credits.visible = true
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_settings_button_pressed():
	SoundManager.click.play()

func _on_exit_button_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	get_tree().quit()



### Levels' functions
func _on_levels_back_button_pressed():
	SoundManager.click.play()
	levels.visible = false
	levels.modulate = Color(1, 1, 1, 0)
	explorer.visible = true
	var tween = create_tween()
	tween.tween_property(explorer, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_tutorial_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_level_1_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()

func _on_level_2_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()

func _on_level_3_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()

func _on_level_4_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()

func _on_level_5_pressed():
	SoundManager.click.play()
	animate_transition()
	await SoundManager.click.finished
	SoundManager.disable_music()



### Credits' functions
func _on_credits_back_button_pressed():
	SoundManager.click.play()
	explorer.visible = true
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	credits.visible = false
