extends Item

@export var freeze_spell_scene: PackedScene

@onready var spells: Node2D = $"../../../../../Spells"

var current_spell: Spell

func _on_used() -> void:
	disabled = true # Disables the button so that player can't broke anything
	current_spell = freeze_spell_scene.instantiate()
	current_spell.global_position = get_global_mouse_position()
	current_spell.modulate.a = 0.0
	current_spell.connect("placed", Callable(self, "_on_spell_placed"))
	spells.add_child(current_spell)
	var tween = create_tween()
	tween.tween_property(current_spell, "modulate:a", 0.33, 0.15)
	await tween.finished
	disabled = false

func _on_deselected() -> void:
	disabled = true # Disables the button so that player can't broke anything
	if current_spell:
		var tween = create_tween()
		tween.tween_property(current_spell, "modulate:a", 0.0, 0.15)
		await tween.finished
		current_spell.queue_free()
	disabled = false

func _on_spell_placed() -> void:
	is_selected = false
	current_spell = null
	var tween = create_tween()
	tween.tween_property(point_light_2d, "color:a", 0.0, 0.15)
	get_parent().get_parent().freeze_item_count -= 1
