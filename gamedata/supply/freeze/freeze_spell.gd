extends Spell

func _on_area_2d_body_entered(body: Enemy) -> void:
	body.speed /= 3
	body.animation_player.speed_scale = 0.33

func _on_area_2d_body_exited(body: Enemy) -> void:
	body.speed *= 3
	body.animation_player.speed_scale = 1
