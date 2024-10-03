extends CanvasLayer

@onready var panel_container = $PanelContainer

func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = get_tree().create_tween()
	tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	queue_free()
