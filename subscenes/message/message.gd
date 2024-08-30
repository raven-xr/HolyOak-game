extends CanvasLayer

var text: String # The value is given by the parent

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label

func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	label.text = text
	
	var tween_1 = create_tween()
	tween_1.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), 1.5)
	await tween_1.finished
	await get_tree().create_timer(1.5).timeout
	var tween_2 = create_tween()
	tween_2.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 1.5)
	await tween_2.finished
	queue_free()
