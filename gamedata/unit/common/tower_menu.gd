extends Control

@onready var build_button: Button = $"PanelContainer/VBoxContainer/Build Button"
@onready var upgrade_button: Button = $"PanelContainer/VBoxContainer/Upgrade Button"
@onready var remove_button: Button = $"PanelContainer/VBoxContainer/Remove Button"
@onready var info_button: Button = $"PanelContainer/VBoxContainer/Info Button"

var unit_name: String
var menu_position: StringName
var tower: Node2D

signal opened()
signal closed()

func _ready() -> void:
	# Displaying the tower menu
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
			position = tower.position + Vector2(-80.0, -184.0)
			pivot_offset = Vector2(80.0, 128.0)
		"R":
			position = tower.position + Vector2(64.0, -64.0)
			pivot_offset = Vector2(0.0, 64.0)
		"D":
			position = tower.position + Vector2(-80.0, 64.0)
			pivot_offset = Vector2(80.0, 0.0)
		"L":
			position = tower.position + Vector2(-224.0, -64.0)
			pivot_offset = Vector2(160.0, 64.0)
	# Set the name
	$Name.text = unit_name

func close() -> void:
	tower.hide_attack_range()
	# Smooth disappearance
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await tween.finished
	closed.emit(self)
	queue_free()
