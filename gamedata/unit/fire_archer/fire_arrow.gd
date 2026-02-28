extends Shell

@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	target.future_health -= damage
	# Connect signals
	target.connect("died", Callable(self, "_on_target_died"))
	target.connect("moved", Callable(self, "_on_target_moved"))
	# Change direction
	change_direction()
	# Animation
	point_light_2d.color.a = 0.0
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.67)
	tween.parallel().tween_property(point_light_2d, "color:a", 1.0, 0.25)

func self_destruct() -> void:
	is_self_destructing = true
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	tween.parallel().tween_property(point_light_2d, "color:a", 0.0, 0.15)
	await get_tree().create_timer(0.11).timeout
	if not hit_enemy:
		var new_hit_effect: AnimatedSprite2D = hit_effect.instantiate()
		new_hit_effect.position = position
		Global.game_controller.current_2d_scene.map.add_child(new_hit_effect)
	await tween.finished
	queue_free()
