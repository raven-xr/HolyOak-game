extends Node2D

@onready var tower = $"."
@onready var animation_player = $AnimationPlayer
@onready var unit_preload = preload("res://scenes/units/archers/unit.tscn")

@export var type: String # The type of tower: Upper (U), Side (S) or Down (D)
@export var flip_h = false # If the tower is side, then it needs to be flipped or not; basic off

func _ready():
	animation_player.play("Level_1")
	await animation_player.animation_finished
	new_unit()

func new_unit():
	var unit = unit_preload.instantiate()
	unit.modulate = Color(1, 1, 1, 0)
	unit.default_view_direction = type
	tower.add_child(unit)
	var tween = get_tree().create_tween()
	tween.tween_property(unit, "modulate", Color(1, 1, 1, 1), 0.15)
