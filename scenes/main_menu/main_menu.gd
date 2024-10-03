extends Node2D

@onready var play_button = $"UserInterface/VBoxContainer/Play Button"
@onready var tutorial_button = $"UserInterface/VBoxContainer/Tutorial Button"
@onready var settings_button = $"UserInterface/VBoxContainer/Settings Button"
@onready var quit_button = $"UserInterface/VBoxContainer/Quit Button"

@export var credits_scene: PackedScene

func _ready():
	SoundManager.music_main.play()

func _on_play_button_pressed():
	SoundManager.click.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")

func _on_tutorial_button_pressed():
	SoundManager.click.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	SoundManager.disable_music()
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_credits_button_pressed():
	SoundManager.click.play()
	add_child(credits_scene.instantiate())

func _on_settings_button_pressed():
	SoundManager.click.play()
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")

func _on_quit_button_pressed():
	SoundManager.click.play()
	await SoundManager.click.finished
	get_tree().quit()

func change_level():
	play_button.disabled = true
	tutorial_button.disabled = true
	settings_button.disabled = true
	quit_button.disabled = true
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_main, "volume_db", -100, 4.0)
