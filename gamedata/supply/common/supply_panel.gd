extends PanelContainer

@onready var freeze_spell: Button = $"HBoxContainer/Freeze Spell"
@onready var freeze_indicator: PointLight2D = $"HBoxContainer/Freeze Spell/PointLight2D"

var selected_item

func _on_freeze_spell_pressed() -> void:
	SoundManager.click.play()
	if freeze_spell != selected_item:
		freeze_indicator.color.a = 0.0
		freeze_indicator.enabled = true
		var tween = create_tween()
		tween.tween_property(freeze_indicator, "color:a", 1.0, 0.15)
		selected_item = freeze_spell
	else:
		selected_item = null
		var tween = create_tween()
		tween.tween_property(freeze_indicator, "color:a", 0.0, 0.15)
		await tween.finished
		freeze_indicator.enabled = false
