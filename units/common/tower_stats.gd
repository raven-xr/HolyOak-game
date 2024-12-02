extends CanvasLayer

# Nodes
@onready var value = $Control/Values/Label
@onready var control = $Control

# These variables is given by the parents
var text: String = ""
var control_position: Vector2 = Vector2(0, 0)
var control_pivot_offset: Vector2 = Vector2(0, 0)


# Common functions
func _ready():
	# Posite
	control.position = control_position
	control.pivot_offset = control_pivot_offset
	# Scale
	control.scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Animate
	control.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0.8), 0.1)
	value.text = text

func close():
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	queue_free()



# Close Button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	close()
