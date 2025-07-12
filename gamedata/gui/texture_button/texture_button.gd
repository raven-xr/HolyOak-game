extends TextureButton

@onready var label: Label = $Label

func _on_mouse_entered() -> void:
	if not disabled:
		label.position.y -= 1

func _on_mouse_exited() -> void:
	if not disabled:
		label.position.y += 1
