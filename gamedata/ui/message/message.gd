extends CanvasLayer

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label

func _ready() -> void:
	# Scale
	panel_container.scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Animate
	panel_container.modulate = Color(1, 1, 1, 0)
	var tween_1 = create_tween()
	tween_1.tween_property(panel_container, "modulate", Color(1, 1, 1, 0.78125), 0.5)
	await tween_1.finished
	var tween_2 = create_tween()
	tween_2.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 1.5)
	tween_2.connect("finished", queue_free)

func set_text(text: String) -> void:
	label.text = text
