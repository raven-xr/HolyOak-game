extends Camera2D

var last_mouse_position: Vector2
var moving: bool = false

func _process(_delta: float) -> void:
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
