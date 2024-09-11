extends CanvasLayer

@onready var level = get_parent().get_parent() # UserInterface node -> Root level node
@onready var click = $SFX/Click
@onready var victory = $SFX/Victory

func _ready():
	victory.play()

func _on_next_button_pressed():
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().change_scene_to_file(level.next_level_path)

func _on_menu_button_pressed():
	click.play()
	await click.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
