extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var click = $SFX/Click
@onready var defeat = $SFX/Defeat

func _ready():
	defeat.play()

func _on_restart_button_pressed():
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)
