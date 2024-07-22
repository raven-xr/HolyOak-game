extends Node2D

const BUILD_COST = 300.0
const MAX_LEVEL = 7
const SPAWNPOINTS = [Vector2(-12, -4), Vector2(14, -4), Vector2(0, 8)]

var upgrade_cost = 0.0
var level = 0:
	set(value):
		level = value
		level_up()
var damage = 0.0

@onready var units = $Units
@onready var animation_player = $AnimationPlayer
@onready var unit_preload = preload("res://scenes/units/archers/unit.tscn")

@export var default_view_direction: String = "D" # The type of tower: Upper (U), Side (S) or Down (D)
@export var default_flip_h: bool = false # If the tower is side, then it needs to be flipped or not; basic off

func _ready():
	animation_player.play("Level_1")
	await animation_player.animation_finished
	# Enabling UpgradeTextureButton
	get_parent().get_parent().get_node("Menu/UpgradeTextureButton").disabled = false
	# get_parent().get_parent() is a tower
	level = 1

func new_unit():
	var unit = unit_preload.instantiate()
	unit.modulate = Color(1, 1, 1, 0)
	unit.default_view_direction = default_view_direction
	unit.default_flip_h = default_flip_h
	unit.position = SPAWNPOINTS[units.get_child_count()]
	units.add_child(unit)
	var tween = get_tree().create_tween()
	tween.tween_property(unit, "modulate", Color(1, 1, 1, 1), 0.15)

func level_up():
	damage = UnitStats.archers[str('level_', level)]['damage']
	upgrade_cost = UnitStats.archers[str('level_', level)]['upgrade_cost']
	if units.get_child_count() < UnitStats.archers[str('level_', level)]['units']:
		new_unit()
