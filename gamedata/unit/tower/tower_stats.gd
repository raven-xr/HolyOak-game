extends Control

@onready var label = $Values/Label

var values: String # Defined by the platform

func _ready():
	# Scale
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Animate
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0.9), 0.1)
	label.text = values

func close():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	queue_free()



# Close Button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	close()
