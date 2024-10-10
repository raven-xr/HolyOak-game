extends TextureButton

@onready var label = $Label

var is_label_hovered: bool = false

func _on_mouse_entered():
	if not disabled:
		label.position.y -= 1
		is_label_hovered = true

func _on_mouse_exited():
	if is_label_hovered:
		label.position.y += 1
