extends Node2D

const BUILD_COST = 300.0
const MAX_LEVEL = 7

var level = 0:
	set(value):
		level = value
		level_up()
var is_upgrading = false
var damage = 0
var attack_range = 10 # Default collision shape's radius
var upgrade_cost = 0
var unit_count = 0
var spawnpoints = []

@onready var units = $Units
@onready var animation_player = $AnimationPlayer
@onready var unit_preload = preload("res://scenes/units/archers/unit.tscn")

func _ready():
	level = 1

func new_unit():
	var unit = unit_preload.instantiate()
	unit.position = spawnpoints[units.get_child_count()]
	units.add_child(unit)
	var tween = get_tree().create_tween()
	tween.tween_property(units, "modulate", Color(1, 1, 1, 1), 0.15)

func level_up():
	# Inform the platform that the tower is being upgraded
	is_upgrading = true
	# Remove units
	var tween = get_tree().create_tween()
	tween.tween_property(units, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	for child in units.get_children():
		child.queue_free()
	# Upgrade stats
	damage = UnitStats.archers[str('level_', level)]['damage']
	upgrade_cost = UnitStats.archers[str('level_', level)]['upgrade_cost']
	unit_count = UnitStats.archers[str('level_', level)]['unit_count']
	spawnpoints = UnitStats.archers[str('level_', level)]['spawnpoints']
	attack_range = UnitStats.archers[str('level_', level)]['attack_range']
	# Play animation
	animation_player.play(str("Level_", level))
	await animation_player.animation_finished
	# Add new units
	for i in range(unit_count):
		new_unit()
	# Inform the platform that the tower finsihed upgrading
	is_upgrading = false
	# If the platform's interface is opened, then enable upgrade button
	if can_be_upgraded():
		get_parent().get_parent().upgrade_texture_button.disabled = false

func can_be_upgraded():
	if is_upgrading or MAX_LEVEL == level:
		return false
	else:
		return true
