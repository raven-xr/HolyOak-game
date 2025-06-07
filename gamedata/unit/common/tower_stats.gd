extends Control

@onready var values_label: Label = $Values/Label

var menu_position: StringName
var tower_position: Vector2

signal opened()
signal closed()

func _ready() -> void:
	opened.emit()
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.9), 0.1)
	# Posite
	match menu_position:
		"U":
			position = tower_position + Vector2(-132.0, -263.0)
			pivot_offset = Vector2(130.0, 202.0)
		"R":
			position = tower_position + Vector2(61.0, -101.0)
			pivot_offset = Vector2(10.0, 101.0)
		"D":
			position = tower_position + Vector2(-132.0, 61.0)
			pivot_offset = Vector2(130.0, 0.0)
		"L":
			position = tower_position + Vector2(-321.0, -101.0)
			pivot_offset = Vector2(260.0, 101.0)

func close() -> void:
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
	await tween.finished
	queue_free()
	closed.emit()

func _on_close_button_pressed() -> void:
	SoundManager.click.play()
	close()
