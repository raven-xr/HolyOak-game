extends CanvasLayer

var text: String # The value is given by the parent

@onready var label = $Label

func _ready():
	label.modulate = Color(1, 1, 1, 0)
	label.text = text
	label.size.x = len(text) * 10.0
	
	var tween_1 = create_tween()
	tween_1.tween_property(label, "modulate", Color(1, 1, 1, 1), 0.5)
	await tween_1.finished
	var tween_2 = create_tween()
	tween_2.tween_property(label, "modulate", Color(1, 1, 1, 0), 3.0)
	await tween_2.finished
	queue_free()
