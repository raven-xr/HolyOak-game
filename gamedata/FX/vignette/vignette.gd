extends ColorRect

@onready var shift_timer: Timer = $"Shift Timer"

@export_group("Pulsation")
## If true, the vignette starts pulsing with the {pulse_amplitude} withing {pulse_time}
@export var pulse: bool = false:
	set(value):
		pulse = value
		if value:
			pulse_up(material.get("shader_parameter/radius"))
## The pulse amplitude determines the maximum and minimum radius of the vignette, 
## so that the maximum is the current radius + (amplitude / 2), 
## and the minimum is the radius + (amplitude / 2)
@export var pulse_amplitude: float = 0.2
## How long will it take between the pulsation from the minimum to the maximum
@export var pulse_time: float = 1.5

@export_group("Shift")
@export var max_vignette_color_shift: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var max_transparency_shift: float = 1.0
@export var max_radius_shift: float = 1.0

var vignette_color_shift: Color = Color(0.0, 0.0, 0.0, 0.0):
	set(value):
		value.r = min(value.r, max_vignette_color_shift.r)
		value.g = min(value.g, max_vignette_color_shift.g)
		value.b = min(value.b, max_vignette_color_shift.b)
		value.a = min(value.a, max_vignette_color_shift.a)
		vignette_color_shift = value
var transparency_shift: float = 0.0:
	set(value):
		value = min(value, max_transparency_shift)
		transparency_shift = value
var radius_shift: float = 0.0:
	set(value):
		value = min(value, max_radius_shift)
		radius_shift = value

func _ready() -> void:
	# Resets shader
	material.set("shader_parameter/vignette_color", Color(0.251, 0.502, 0.0, 1.0))
	material.set("shader_parameter/transparency", 0.3)
	material.set("shader_parameter/radius", 2.0)

## Changes color within {duration} seconds[br]
## Set a small value of the duration if you want to change it instantly
func set_vignette_color(value: Color, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/vignette_color", value, duration)
	await tween.finished

## Shifts the color by {value} within {duration} seconds and
## then returns it in {max(value.r, value.g, value.b, value.a) * 5} seconds
func shift_vignette_color(value: Color, duration: float) -> void:
	# Restart the shift timer if it's not paused
	if not shift_timer.paused:
		shift_timer.stop()
	shift_timer.start()
	# Shift it if the property hasn't reached maximum yet
	if vignette_color_shift.r == max_vignette_color_shift.r or \
	vignette_color_shift.g == max_vignette_color_shift.g or \
	vignette_color_shift.b == max_vignette_color_shift.b or \
	vignette_color_shift.a == max_vignette_color_shift.a:
		return
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/vignette_color", material.get("shader_parameter/vignette_color") + value, duration)
	await tween.finished
	vignette_color_shift += value
	shift_timer.wait_time = 5.0

## Changes color within {duration} seconds[br]
## Set a small value of the duration if you want to change it instantly
func set_transparency(value: float, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/transparency", value, duration)
	await tween.finished

## Shifts the transparency by {value} within {duration} seconds and
## then returns it in {value * 5} seconds
func shift_transparency(value, duration: float) -> void:
	# Restart the shift timer if it's not paused
	if not shift_timer.paused:
		shift_timer.stop()
	shift_timer.start()
	# Shift it if the property hasn't reached maximum yet
	if transparency_shift == max_transparency_shift:
		return
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/transparency", material.get("shader_parameter/transparency") + value, duration)
	await tween.finished
	transparency_shift += value
	shift_timer.wait_time = 5.0

## Changes radius within {duration} seconds[br]
## Set a small value of the duration if you want to change it instantly
func set_radius(value: float, duration: float = 0.001) -> void:
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/radius", value, duration)
	await tween.finished

## Shifts the radius by {value} within {duration} seconds and
## then returns it in {value * 5} seconds
func shift_radius(value, duration: float) -> void:
	# Restart the shift timer if it's not paused
	if not shift_timer.paused:
		shift_timer.stop()
	shift_timer.start()
	# Shift it if the property has't reached maximum yet
	if radius_shift == max_radius_shift:
		return
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/radius", material.get("shader_parameter/radius") + value, duration)
	await tween.finished
	radius_shift += value
	shift_timer.wait_time = 5.0

func pulse_up(original_radius: float) -> void:
	var inaccuracy: float = randf_range(0.0, pulse_amplitude / 4) # Makes the animation more dynamic
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/radius", original_radius + pulse_amplitude / 2 + inaccuracy, pulse_time)
	await tween.finished
	if pulse: # Checks whether player disabled pulsation or not
		await get_tree().create_timer(0.1).timeout
		pulse_down(original_radius)
	else:
		set_radius(original_radius)

func pulse_down(original_radius: float) -> void:
	var inaccuracy: float = randf_range(-pulse_amplitude / 4, 0.0) # Makes the animation more dynamic
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/radius", original_radius - pulse_amplitude / 2 + inaccuracy, pulse_time)
	await tween.finished
	if pulse: # Checks whether player disabled pulsation or not
		await get_tree().create_timer(0.1).timeout
		pulse_up(original_radius)
	else:
		set_radius(original_radius)

func _on_shift_timer_timeout() -> void:
	var tween = create_tween()
	if vignette_color_shift != Color(0.0, 0.0, 0.0, 0.0):
		# Returns the color shift in {6.0 * max(vignette_color_shift.r, vignette_color_shift.g, vignette_color_shift.b, vignette_color_shift.a)} seconds.
		# e.g. Color(1.0, 0.9, 0.0, 0.1) will be shifted in 6.0 seconds
		tween.parallel().tween_property(material, "shader_parameter/vignette_color", material.get("shader_parameter/vignette_color") - vignette_color_shift, 6.0 * max(vignette_color_shift.r, vignette_color_shift.g, vignette_color_shift.b, vignette_color_shift.a))
	if transparency_shift != 0.0:
		# Returns the transparency shift in {6.0 * transparency_shift} seconds.
		# e.g. 2.0 will be shifted in 15 seconds
		tween.parallel().tween_property(material, "shader_parameter/transparency", material.get("shader_parameter/transparency") - transparency_shift, 6.0 * transparency_shift)
	if radius_shift != 0.0:
		# Returns the radius shift in {6.0 * radius_shift} seconds.
		# e.g. 2.0 will be shifted in 6.0 seconds
		tween.parallel().tween_property(material, "shader_parameter/radius", material.get("shader_parameter/radius") - radius_shift, 6.0 * radius_shift)
