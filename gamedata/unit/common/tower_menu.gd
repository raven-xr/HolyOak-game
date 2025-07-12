extends Control

@onready var build_button = $"Build Button"
@onready var upgrade_button = $"Upgrade Button"
@onready var remove_button = $"Remove Button"
@onready var tower_stats_button = $"Tower Stats Button"

var unit_name: String
var menu_position: StringName
var tower: Node2D

signal opened()
signal closed()

func _ready() -> void:
	opened.emit(self)
	tower.show_attack_range()
	scale = Vector2(UserSettings.gui_scale**1.5, UserSettings.gui_scale**1.5)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
	# Posite the menu
	match menu_position:
		"U":
			position = tower.position + Vector2(-180.0, -224.0)
			pivot_offset = Vector2(180.0, 180.0)
		"R":
			position = tower.position + Vector2(56.0, -90.0)
			pivot_offset = Vector2(0.0, 90.0)
		"D":
			position = tower.position + Vector2(-180.0, 56.0)
			pivot_offset = Vector2(180.0, 0.0)
		"L":
			position = tower.position + Vector2(-414.0, -90.0)
			pivot_offset = Vector2(358.0, 64.0)
	# Set the unit name
	$UnitName.text = unit_name

func close() -> void:
	tower.hide_attack_range()
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await tween.finished
	closed.emit(self)
	queue_free()
