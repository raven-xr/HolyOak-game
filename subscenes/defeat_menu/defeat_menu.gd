extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var click = $SFX/Click
@onready var defeat = $SFX/Defeat
@onready var menu_button = $"PanelContainer/Menu Button"
@onready var restart_button = $"PanelContainer/Restart Button"

func _ready():
	get_tree().paused = true
	defeat.play()

func _on_restart_button_pressed():
	click.play()
	await click.finished
	change_level()
	#await get_tree().create_timer(4.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	click.play()
	await click.finished
	change_level()
	#await get_tree().create_timer(4.0).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)

func change_level():
	menu_button.disabled = true
	restart_button.disabled = true
	#var tween_1 = get_tree().create_tween()
	#tween_1.parallel().tween_property(level, "modulate", Color(0, 0, 0, 1), 2.0)
	#var tween_2 = get_tree().create_tween()
	#tween_2.parallel().tween_property(level.radio_fight, "volume_db", -100, 4.0)
