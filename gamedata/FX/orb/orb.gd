extends GPUParticles2D

func _on_fight_started() -> void:
	# Make orbs red
	var tween = create_tween()
	tween.tween_property(process_material, "color", Color(1.0, 0.0, 0.0, 1.0), 4.0)
