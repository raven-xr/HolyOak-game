extends CanvasLayer

# These variables are given by the parent
var text: String = ""

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label

func _ready():
	panel_container.modulate = Color(1, 1, 1, 0)
	label.text = text
	
	var tween_1 = create_tween()
	tween_1.tween_property(panel_container, "modulate", Color(1, 1, 1, 0.78125), 0.5)
	await tween_1.finished
	var tween_2 = create_tween()
	tween_2.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), 1.5)
	tween_2.connect("finished", queue_free)
