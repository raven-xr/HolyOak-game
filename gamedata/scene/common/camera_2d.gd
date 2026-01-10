extends Camera2D

@export_category("Shaking")
@export var random_strength: float = 5.0
@export var shake_fade: float = 10.0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var shake_strength: float = 0.0

var last_mouse_position: Vector2
var moving: bool = false

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()
	if moving:
		var current_mouse_position: Vector2 = get_viewport().get_mouse_position()
		position += (last_mouse_position - current_mouse_position) * 0.33
		last_mouse_position = current_mouse_position

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_wheel_up"):
		if zoom.x == 1.0:
			position = get_viewport().get_mouse_position()
		zoom.x += 0.025
		zoom.y += 0.025
		if zoom.x > 2.0:
			zoom = Vector2(2.0, 2.0)
	if Input.is_action_just_pressed("ui_wheel_down"):
		zoom.x -= 0.025
		zoom.y -= 0.025
		if zoom.x < 1.0:
			zoom = Vector2(1.0, 1.0)
	if Input.is_action_just_pressed("ui_click"):
		moving = true
		last_mouse_position = get_viewport().get_mouse_position()
	if Input.is_action_just_released("ui_click"):
		moving = false

func shake():
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
