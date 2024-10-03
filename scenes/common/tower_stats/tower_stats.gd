extends Node2D

@onready var value = $Values/Label

func _ready():
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
	update_data()

func update_data():
	var tower = get_parent().get_node("Tower")
	value.text = str(tower.attack_range, "\n", tower.damage, "\n", tower.unit_count, "\n", tower.current_cost, "\n", PlayerStats.max_level)

func _on_update_data_button_pressed():
	SoundManager.click.play()
	var tween_1 = create_tween()
	tween_1.tween_property(value, "theme_override_colors/font_color", Color(1, 1, 1, 0), 0.1)
	await tween_1.finished
	update_data()
	var tween_2 = create_tween()
	tween_2.tween_property(value, "theme_override_colors/font_color", Color(1, 1, 1, 1), 0.1)

func _on_close_button_pressed():
	SoundManager.click.play()
	close()

func close():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	queue_free()
