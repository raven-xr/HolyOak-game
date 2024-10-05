extends Control

@onready var v_box_container = $Explorer/VBoxContainer

@onready var play_button = $"Explorer/VBoxContainer/Play Button"
@onready var tutorial_button = $"Explorer/VBoxContainer/Tutorial Button"
@onready var settings_button = $"Explorer/VBoxContainer/Settings Button"
@onready var quit_button = $"Explorer/VBoxContainer/Quit Button"

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
	await SoundManager.click.finished
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
	change_level()
	await SoundManager.click.finished
	get_tree().quit()

func change_level():
	for button in v_box_container.get_children():
		button.disabled = true
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 0.1)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_main, "volume_db", -100, 0.2)
