extends TextureButton

@export var text: String = 'TEXT'
@export var font_size: int = 16

@onready var label = $Label

var is_label_hovered: bool = false

func _ready():
	label.set("text", text)
	label.set("theme_override_font_sizes/font_size", font_size)

func _on_mouse_entered():
	if not disabled:
		label.position.y -= 1
		is_label_hovered = true

func _on_mouse_exited():
	if is_label_hovered:
		label.position.y += 1
