extends Camera2D

@export_category("Shaking")
@export var random_strength: float = 5.0
### Never set the shake fade <= 0.5 if you don't want the endless shaking
@export var shake_fade: float = 10.0

const MAX_ZOOM: float = 2.0
const MIN_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.25
const ZOOM_RATE: float = 8.0

var target_zoom: float = 1.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _physics_process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()
	zoom = lerp(zoom, target_zoom * Vector2.ONE, ZOOM_RATE * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative * zoom * 0.25
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if 0.99 <= zoom.x and zoom.x <= 1.01:
					position = get_global_mouse_position()
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()

func zoom_in() -> void:
	target_zoom = min(target_zoom + ZOOM_INCREMENT, MAX_ZOOM)

func zoom_out() -> void:
	target_zoom = max(target_zoom - ZOOM_INCREMENT, MIN_ZOOM)

func shake():
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
