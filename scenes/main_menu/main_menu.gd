extends Control

# Explorer variables
@onready var v_box_container = $Explorer/VBoxContainer
@onready var play_button = $"Explorer/VBoxContainer/Play Button"
@onready var tutorial_button = $"Explorer/VBoxContainer/Tutorial Button"
@onready var settings_button = $"Explorer/VBoxContainer/Settings Button"
@onready var quit_button = $"Explorer/VBoxContainer/Quit Button"

# Credits variables
@onready var credits = $Credits
@onready var close_button = $"Credits/Close Button"



### Common functions
func _ready():
	SoundManager.music_main.play()
	credits.modulate = Color(1, 1, 1, 0)
	
func change_level():
	for button in v_box_container.get_children():
		button.disabled = true
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 0.1)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_main, "volume_db", -100, 0.2)



### Explorer functions
func _on_play_button_pressed():
	SoundManager.click.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")

func _on_tutorial_button_pressed():
	SoundManager.click.play()
	change_level()
	await SoundManager.click.finished
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_credits_button_pressed():
	SoundManager.click.play()
	credits.visible = true
	close_button.disabled = false
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_settings_button_pressed():
	SoundManager.click.play()
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")

func _on_quit_button_pressed():
	SoundManager.click.play()
	change_level()
	await SoundManager.click.finished
	get_tree().quit()



### Credits functions
func _on_close_button_pressed():
	close_button.disabled = true
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(credits, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	credits.visible = false
