extends Control

@onready var build_button: Button = $"PanelContainer/VBoxContainer/Build Button"
@onready var upgrade_button: Button = $"PanelContainer/VBoxContainer/Upgrade Button"
@onready var remove_button: Button = $"PanelContainer/VBoxContainer/Remove Button"
@onready var info_button: Button = $"PanelContainer/VBoxContainer/Info Button"

@onready var build_cost: HBoxContainer = $"Build Cost"
@onready var upgrade_cost: HBoxContainer = $"Upgrade Cost"
@onready var remove_compensation: HBoxContainer = $"Remove Compensation"

var unit_name: String
var unit_logo: Texture2D
var menu_position: StringName
var tower: Node2D

signal opened()
signal closed()

func _ready() -> void:
	$"Name/Logo 1".texture = unit_logo
	$"Name/Logo 2".texture = unit_logo
	
	$"Build Cost/Cost".text = str("−", tower.current_cost)
	$"Upgrade Cost/Cost".text = str("−", tower.current_cost)
	$"Remove Compensation/Size".text = str("+", tower.total_cost)
	
	build_cost.visible = false
	upgrade_cost.visible = false
	remove_compensation.visible = false
	build_cost.modulate = Color.TRANSPARENT
	upgrade_cost.modulate = Color.TRANSPARENT
	remove_compensation.modulate = Color.TRANSPARENT
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



func _on_build_button_mouse_entered() -> void:
	if not build_button.disabled:
		build_cost.visible = true
		var tween = create_tween()
		tween.tween_property(build_cost, "modulate", Color.WHITE, 0.15)

func _on_build_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(build_cost, "modulate", Color.TRANSPARENT, 0.15)
	await tween.finished
	build_cost.visible = false



func _on_upgrade_button_mouse_entered() -> void:
	if not upgrade_button.disabled:
		upgrade_cost.visible = true
		var tween = create_tween()
		tween.tween_property(upgrade_cost, "modulate", Color.WHITE, 0.15)

func _on_upgrade_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(upgrade_cost, "modulate", Color.TRANSPARENT, 0.15)
	await tween.finished
	upgrade_cost.visible = false



func _on_remove_button_mouse_entered() -> void:
	if not remove_button.disabled:
		remove_compensation.visible = true
		var tween = create_tween()
		tween.tween_property(remove_compensation, "modulate", Color.WHITE, 0.15)

func _on_remove_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(remove_compensation, "modulate", Color.TRANSPARENT, 0.15)
	await tween.finished
	remove_compensation.visible = false
