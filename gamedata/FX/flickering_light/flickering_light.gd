extends PointLight2D

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	var rng: float = randf_range(0.4, 0.6)
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "energy", rng, timer.wait_time)
	tween.tween_property(self, "texture_scale", rng * 3, timer.wait_time)
	timer.wait_time = randf_range(0.8, 1.2)
