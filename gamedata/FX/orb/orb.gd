extends GPUParticles2D

func _on_fight_started() -> void:
	# Make orbs yellow
	var tween_1 = create_tween()
	tween_1.tween_property(process_material, "color:r", 1.0, 7.5)
	await tween_1.finished
	# Make orbs red
	var tween_2 = create_tween()
	tween_2.tween_property(process_material, "color:g", 0.0, 7.5)
