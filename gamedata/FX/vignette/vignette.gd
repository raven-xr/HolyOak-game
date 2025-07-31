extends ColorRect

func _ready() -> void:
	# Resets shader
	material.set("shader_parameter/vignette_color", Color(0.251, 0.502, 0.0, 1.0))
	material.set("shader_parameter/MainAlpha", 0.3)
	material.set("shader_parameter/outerRadius", 2.0)

## Changes color within {duration} seconds[br]
## By default, duration = 0.001, so it happens instantly, set the duration if you want to
## change it smoothly
func set_vignette_color(vignette_color: Color, duration: float = 0.001) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/vignette_color", vignette_color, duration)

## Changes transparency within {duration} seconds[br]
## By default, duration = 0.001, so it happens instantly, set the duration if you want to
## change it smoothly
func set_transparency(alpha: float, duration: float = 0.001) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/MainAlpha", alpha, duration)

## Changes radius within {duration} seconds[br]
## By default, duration = 0.001, so it happens instantly, set the duration if you want to
## change it smoothly
func set_radius(radius: float, duration: float = 0.001) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/outerRadius", radius, duration)
