extends CanvasLayer

@onready var control = $Control

func _ready():
	control.modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = get_tree().create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	queue_free()
