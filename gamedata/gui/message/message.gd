extends NodeGUI

@onready var panel_container: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/Label

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	var tween_2 = create_tween()
	tween_2.tween_property(panel_container, "modulate:a", 0.0, 1.0)
	await tween_2.finished
	queue_free()

func set_text(text: String) -> void:
	label.text = text
