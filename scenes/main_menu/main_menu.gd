extends Node2D

@onready var play_texture_button = $"UserInterface/VBoxContainer/Play TextureButton"
@onready var tutorial_texture_button = $"UserInterface/VBoxContainer/Tutorial TextureButton"
@onready var settings_texture_button = $"UserInterface/VBoxContainer/Settings TextureButton"
@onready var quit_texture_button = $"UserInterface/VBoxContainer/Quit TextureButton"

func _ready():
	SoundManager.music_main.play()

func _on_play_texture_button_pressed():
	SoundManager.click.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")

func _on_tutorial_texture_button_pressed():
	SoundManager.click.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_settings_texture_button_pressed():
	SoundManager.click.play()
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")

func _on_quit_texture_button_pressed():
	SoundManager.click.play()
	await SoundManager.click.finished
	get_tree().quit()

func change_level():
	play_texture_button.disabled = true
	tutorial_texture_button.disabled = true
	settings_texture_button.disabled = true
	quit_texture_button.disabled = true
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_main, "volume_db", -100, 4.0)
