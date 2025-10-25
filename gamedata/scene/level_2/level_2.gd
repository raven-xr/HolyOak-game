extends Level

@onready var rain: GPUParticles2D = $GFX/Rain
@onready var ambience: AudioStreamPlayer = $SFX/Ambience

func victory() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(rain, "modulate:a", 0.0, 4.0)
	tween.tween_property(ambience, "volume_linear", 0.0, 4.0)
	# Save
	UserData.progress[technical_name]["is_completed"] = true
	UserData.progress[technical_name]["stars"] = 3
	UserData.update_save()
	await tween.finished
	var victory_menu = victory_menu_scene.instantiate()
	gui.add_child(victory_menu)
	menu_button.disabled = true

func _on_campfire_timer_timeout() -> void:
	$"Map/Hill 1/Campfire/GPUParticles2D".one_shot = true
