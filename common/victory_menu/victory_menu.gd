extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var menu_button = $"PanelContainer/Menu Button"
@onready var next_button = $"PanelContainer/Next Button"

func _ready():
	get_tree().paused = true
	SoundManager.victory.play()

func _on_next_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	change_level()
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)

func _on_menu_button_pressed():
	SoundManager.click.play()
	SoundManager.disable_music()
	change_level()
	#await get_tree().create_timer(4.0).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func change_level():
	menu_button.disabled = true
	next_button.disabled = true
	#var tween_1 = create_tween()
	#tween_1.parallel().tween_property(level, "modulate", Color(0, 0, 0, 1), 2.0)
	#var tween_2 = create_tween()
	#tween_2.parallel().tween_property(level.radio_fight, "volume_db", -100, 4.0)
