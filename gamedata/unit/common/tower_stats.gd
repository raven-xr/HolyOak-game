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
			position = tower_position + Vector2(-184.0, -368.0)
			pivot_offset = Vector2(182.0, 282.0)
		"R":
			position = tower_position + Vector2(90.0, -140.0)
			pivot_offset = Vector2(14.0, 140.0)
		"D":
			position = tower_position + Vector2(-182.0, 90.0)
			pivot_offset = Vector2(182.0, 0.0)
		"L":
			position = tower_position + Vector2(-448.0, -140.0)
			pivot_offset = Vector2(364.0, 140.0)

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
