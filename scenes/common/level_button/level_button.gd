extends TextureButton

@onready var label = $Label

func _on_mouse_entered():
	if not disabled:
		label.position.y -= 1

func _on_mouse_exited():
	if not disabled:
		label.position.y += 1
