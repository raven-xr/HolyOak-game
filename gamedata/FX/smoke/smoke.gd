extends AnimatedSprite2D

var animations = ["Smoke_05_01", "Smoke_05_07", "Smoke_05_08"]
var is_active = true

func _ready():
	scale.x = randf_range(0.9, 1.1)
	scale.y = scale.x
	play(animations[randi_range(0, 2)])
	shake()

func shake():
	var final_value = position - Vector2(randf_range(-2, 2), randf_range(-2, 2))
	var tween = create_tween()
	tween.parallel().tween_property(self, "position", final_value, 0.2)
	await tween.finished
	shake()

func _on_animation_finished():
	if is_active:
		play(animations[randi_range(0, 2)])
	else:
		queue_free()
