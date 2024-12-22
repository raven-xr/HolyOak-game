extends PanelContainer



@onready var level = get_parent().get_parent()

@onready var menu_button = $"Menu Button"
@onready var next_button = $"Next Button"



func _ready():
	# Scale
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Animate
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	# Pause the game
	get_tree().paused = true
	# Play SFX
	SoundManager.victory.play()

func disable_buttons():
	menu_button.disabled = true
	next_button.disabled = true



# Menu Button's functions
func _on_menu_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")



# Next Button's functions
func _on_next_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	disable_buttons()
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)
