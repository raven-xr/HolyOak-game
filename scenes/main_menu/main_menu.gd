extends Node2D
@onready var click_2d = $SFX/Click2D
@onready var radio = $SFX/Radio

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(radio, "volume_db", -5.0, 5.0)

func _on_play_texture_button_pressed():
	change_scene()
	await get_tree().create_timer(8.0).timeout
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")

func _on_settings_texture_button_pressed():
	change_scene()
	await get_tree().create_timer(8.0).timeout
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")

func _on_quit_texture_button_pressed():
	change_scene()
	await get_tree().create_timer(8.0).timeout
	get_tree().quit()

func change_scene():
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(0, 0, 0, 1), 4.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio, "volume_db", -100, 8.0)
