extends Control

@onready var build_button = $"Build Button"
@onready var upgrade_button = $"Upgrade Button"
@onready var remove_button = $"Remove Button"
@onready var tower_stats_button = $"Tower Stats Button"

var unit_name: String
var menu_position: StringName
var tower_position: Vector2
var is_closing: bool = false

func _ready() -> void:
	scale = Vector2(UserSettings.gui_scale**1.5, UserSettings.gui_scale**1.5)
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)
	# Posite the menu
	match menu_position:
		"U":
			position = tower_position + Vector2(-128.0, -160.0)
			pivot_offset = Vector2(128.0, 128.0)
		"R":
			position = tower_position + Vector2(40.0, -64.0)
			pivot_offset = Vector2(0.0, 64.0)
		"D":
			position = tower_position + Vector2(-128.0, 40.0)
			pivot_offset = Vector2(128.0, 0.0)
		"L":
			position = tower_position + Vector2(-296.0, -64.0)
			pivot_offset = Vector2(256.0, 64.0)
	# Set the unit name
	$UnitName.text = unit_name

func close() -> void:
	is_closing = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await tween.finished
	queue_free()
