extends Node2D
@onready var tower = $"."
@onready var animation_player = $AnimationPlayer
@onready var unit_preload = preload("res://scenes/units/archers/unit.tscn")

func _ready():
	animation_player.play("Level_1")
	await animation_player.animation_finished
	#var tween = get_tree().create_tween()
	#tween.tween_property(archer, "modulate:a", 1.0, 0.1)
	new_unit()

func new_unit():
	var unit = unit_preload.instantiate()
	unit.position = Vector2(150, 125)
	unit.modulate = Color(1, 1, 1, 0)
	tower.add_child(unit)
	var tween = get_tree().create_tween()
	tween.tween_property(unit, "modulate", Color(1, 1, 1, 1), 0.15)
