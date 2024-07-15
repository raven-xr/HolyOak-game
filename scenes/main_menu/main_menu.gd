extends Node2D
@onready var click_2d = $SFX/Click2D
@onready var radio = $SFX/Radio
@onready var play_texture_button = $UserInterface/VBoxContainer/Play_TextureButton
@onready var tutorial_texture_button = $UserInterface/VBoxContainer/Tutorial_TextureButton
@onready var settings_texture_button = $UserInterface/VBoxContainer/Settings_TextureButton
@onready var quit_texture_button = $UserInterface/VBoxContainer/Quit_TextureButton

func _ready():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/units/archers/tower.tscn") # TEST
	var tween = get_tree().create_tween()
	tween.tween_property(radio, "volume_db", -4.0, 4.0)

func _on_play_texture_button_pressed():
	click_2d.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")

func _on_tutorial_texture_button_pressed():
	click_2d.play()
	change_level()
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_settings_texture_button_pressed():
	click_2d.play()
	await click_2d.finished
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")

func _on_quit_texture_button_pressed():
	click_2d.play()
	await click_2d.finished
	get_tree().quit()

func change_level():
	play_texture_button.disabled = true
	tutorial_texture_button.disabled = true
	settings_texture_button.disabled = true
	quit_texture_button.disabled = true
	
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio, "volume_db", -100, 4.0)
