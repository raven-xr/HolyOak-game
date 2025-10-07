extends Item

func _on_used() -> void:
	var level: Level = Global.game_controller.current_2d_scene
	if level.max_health - level.health >= 50:
		level.health += 50
		$AudioStreamPlayer.play()
		get_parent().get_parent().heal_item_count -= 1
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("Дерево и так здорово!")
