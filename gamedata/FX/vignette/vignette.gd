extends ColorRect

@export_group("Pulsation")
## If true, the vignette starts pulsing with the {pulse_amplitude} withing {pulse_time}
@export var pulse: bool = false:
	set(value):
		pulse = value
		if value:
			pulse_up()
## The pulse amplitude determines the maximum and minimum radius of the vignette, 
## so that the maximum is the current radius + (amplitude / 2), 
## and the minimum is the radius + (amplitude / 2)
@export var pulse_amplitude: float = 0.2
## How long will it take between the pulsation from the minimum to the maximum
@export var pulse_time: float = 1.5
## The value of this variable is updated only if the user had used the "set_radius()" function, 
## so that the pulsation doesn't change it
@onready var radius: float = material.get("shader_parameter/outerRadius")

func _ready() -> void:
	# Resets shader
	material.set("shader_parameter/vignette_color", Color(0.251, 0.502, 0.0, 1.0))
	material.set("shader_parameter/MainAlpha", 0.3)
	material.set("shader_parameter/outerRadius", 2.0)

## Changes color within {duration} seconds[br]
## By default, duration = 0.001, so it happens instantly, set the duration if you want to
## change it smoothly
func set_vignette_color(value: Color, duration: float = 0.001) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/vignette_color", value, duration)

## Changes transparency within {duration} seconds[br]
## By default, duration = 0.001, so it happens instantly, set the duration if you want to
## change it smoothly
func set_transparency(value: float, duration: float = 0.001) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/MainAlpha", value, duration)

## Changes radius within {duration} seconds[br]
## By default, duration = 0.001, so it happens instantly, set the duration if you want to
## change it smoothly
func set_radius(value: float, duration: float = 0.001) -> void:
	radius = value # Update the value of the radius variable
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/outerRadius", value, duration)

func pulse_up() -> void:
	var inaccuracy: float = randf_range(0.0, pulse_amplitude / 4) # Makes the animation more dynamic
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/outerRadius", radius + pulse_amplitude / 2 + inaccuracy, pulse_time)
	await tween.finished
	if pulse: # Checks whether player disabled pulsation or not
		await get_tree().create_timer(0.1).timeout
		pulse_down()
	else:
		set_radius(radius)

func pulse_down() -> void:
	var inaccuracy: float = randf_range(-pulse_amplitude / 4, 0.0) # Makes the animation more dynamic
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/outerRadius", radius - pulse_amplitude / 2 + inaccuracy, pulse_time)
	await tween.finished
	if pulse: # Checks whether player disabled pulsation or not
		await get_tree().create_timer(0.1).timeout
		pulse_up()
	else:
		set_radius(radius)
