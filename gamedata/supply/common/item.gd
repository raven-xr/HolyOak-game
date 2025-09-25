extends Button
class_name Item

## What happens after this item is seleceted
@export_group("Indication")
@export var glow: bool = true

@onready var point_light_2d: PointLight2D = $PointLight2D

var is_selected: bool = false

signal selected()
signal deselected()

func _ready() -> void:
	point_light_2d.color.a = 0.0

func _on_pressed() -> void:
	SoundManager.click.play()
	if not is_selected:
		var tween = create_tween()
		tween.tween_property(point_light_2d, "color:a", 1.0, 0.15)
		is_selected = true
		selected.emit()
	else:
		var tween = create_tween()
		tween.tween_property(point_light_2d, "color:a", 0.0, 0.15)
		is_selected = false
		deselected.emit()
