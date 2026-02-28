extends PointLight2D

@export_group("Flickering")
@export var target_texture_scale: float = 1.5
@export var target_energy: float = 0.5
@export var amplitude: float = 0.4

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	var k: float = randf_range(1 - amplitude / 2, 1 + amplitude / 2)
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "energy", target_energy * k, timer.wait_time)
	tween.tween_property(self, "texture_scale", target_texture_scale * k, timer.wait_time)
	timer.wait_time = randf_range(0.8, 1.2)
