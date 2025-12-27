extends AnimatedSprite2D

func _ready():
	play(str(randi_range(1, 3)))

func _on_animation_finished() -> void:
	queue_free()
