extends Item

@export var freeze_spell_scene: PackedScene

@onready var spells: Node2D = Global.game_controller.current_2d_scene.get_node("Spells")

@onready var use_button: Button = $VBoxContainer/UseButton
@onready var cancel_button: Button = $VBoxContainer/CancelButton

var current_spell: Spell:
	set(value):
		if value:
			cancel_button.disabled = false
		else:
			cancel_button.disabled = true
		current_spell = value

func _on_used() -> void:
	use_button.disabled = true
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

func _on_spell_placed() -> void:
	use_button.disabled = false
	is_selected = false
	current_spell = null
	var tween = create_tween()
	tween.tween_property(point_light_2d, "color:a", 0.0, 0.15)
	get_parent().get_parent().freeze_item_count -= 1

func _on_cancel_button_pressed() -> void:
	deselect()
	var tween = create_tween()
	tween.tween_property(current_spell, "modulate:a", 0.0, 0.15)
	await tween.finished
	current_spell.queue_free()
	current_spell = null
	use_button.disabled = false
