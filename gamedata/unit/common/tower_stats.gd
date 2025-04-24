extends Control



@onready var label: Label = $Values/Label



func _ready() -> void:
	# Scale
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)

func open() -> void:
	visible = true
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	# Smooth appearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.9), 0.1)

func close() -> void:
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
	await tween.finished
	visible = false

func _on_close_button_pressed() -> void:
	SoundManager.click.play()
	close()
