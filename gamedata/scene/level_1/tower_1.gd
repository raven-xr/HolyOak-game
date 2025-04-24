extends "res://gamedata/unit/common/tower.gd"



@onready var level_1: Level = $"../.."

signal player_opened_menu()
signal player_built_tower()
signal player_upgraded_tower()
signal player_opened_tower_stats()

var is_tower_stats_button_locked: bool = true
var is_remove_button_locked: bool = true



func open_menu() -> void:
	menu.visible = true
	unit_name.visible = true
	# Smooth appearance
	var tween_1 = create_tween()
	tween_1.tween_property(menu, "modulate", Color(1, 1, 1, 1), 0.1)
	var tween_2 = create_tween()
	tween_2.tween_property(unit_name, "modulate", Color(1, 1, 1, 1), 0.1)
	# Close tower stats if they are opened
	if tower_stats.visible:
		tower_stats.close()
	# Disable buttons (unique for this tower)
	if level > 0:
		build_button.disabled = true
		if not can_be_upgraded():
			upgrade_button.disabled = true
		if is_tower_stats_button_locked:
			tower_stats_button.disabled = true
		if is_remove_button_locked:
			remove_button.disabled = true
	else:
		tower_stats_button.disabled = true
		remove_button.disabled = true
		upgrade_button.disabled = true

func _on_touch_screen_button_pressed() -> void:
	SoundManager.click.play()
	if not menu.visible:
		open_menu()
	else:
		close_menu()
	player_opened_menu.emit()

func _on_build_button_pressed() -> void:
	SoundManager.click.play()
	# Check whether player has enough money
	if PlayerStats.money >= current_cost:
		upgrade()
	else:
		var new_message = message_scene.instantiate()
		new_message.text = "У вас недостаточно монет. Текущая стоимость строительства — " + str(current_cost) + " монет"
		add_child(new_message)
	close_menu()
	player_built_tower.emit()

func _on_upgrade_button_pressed() -> void:
	SoundManager.click.play()
	# Check whether player has enough money
	if PlayerStats.money >= current_cost:
		upgrade()
	else:
		var new_message = message_scene.instantiate()
		new_message.text = "У вас недостаточно монет. Текущая стоимость улучшения — " + str(current_cost) + " монет"
		add_child(new_message)
	close_menu()
	player_upgraded_tower.emit()

func _on_tower_stats_button_pressed() -> void:
	SoundManager.click.play()
	# The dictionary is required for positioning tower stats and offsetting their pivots
	const POSITIONS: Dictionary[StringName, Dictionary] = {
		"U": {
			"position": Vector2(-132, -263),
			"pivot_offset": Vector2(130, 202)
			},
		"R": {
			"position": Vector2(61, -101),
			"pivot_offset": Vector2(10, 101)
			},
		"D": {
			"position": Vector2(-132, 61),
			"pivot_offset": Vector2(130, 0)
			},
		"L": {
			"position": Vector2(-321, -101),
			"pivot_offset": Vector2(260, 101)
			}
	}
	tower_stats.label.text = str(
		unit_stats["level_" + str(level)]["attack_range"], "\n",
		unit_stats["level_" + str(level)]["damage"], "\n",
		unit_stats["level_" + str(level)]["count"], "\n",
		current_cost, "\n",
		tower_level_limit
	)
	tower_stats.position = global_position + POSITIONS[menu_position]["position"]
	tower_stats.pivot_offset = POSITIONS[menu_position]["pivot_offset"]
	tower_stats.open()
	close_menu()
	player_opened_tower_stats.emit()

func _on_level_1_player_ended_tutorial() -> void:
	# Enable the remove button if the menu is opened
	if menu.visible:
		remove_button.disabled = false
