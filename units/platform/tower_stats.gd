extends Control

@onready var value = $Values/Label

func _ready():
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0.8), 0.1)
	var tower = get_parent().get_node("Tower")
	value.text = str(tower.attack_range, "\n", tower.damage, "\n", tower.unit_count, "\n", tower.current_cost, "\n", PlayerStats.max_level)

func _on_close_button_pressed():
	SoundManager.click.play()
	close()

func close():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	queue_free()
