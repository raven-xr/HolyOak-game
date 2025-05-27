extends "res://gamedata/unit/common/tower.gd"



@onready var level_1: Level = $"../.."

signal player_opened_menu()
signal player_built_tower()
signal player_upgraded_tower()
signal player_opened_tower_stats()

var is_tower_stats_button_locked: bool = true
var is_remove_button_locked: bool = true

func open_menu() -> void:
	tower_menu = tower_menu_scene.instantiate()
	tower_menu.unit_name = unit_scene.instantiate().name
	tower_menu.menu_position = menu_position
	tower_menu.tower_position = position
	# Connects the "opened" and "closed" signals to the level
	tower_menu.connect("opened", Callable(Global.game_controller.current_2d_scene, "_on_tower_menu_opened"))
	tower_menu.connect("closed", Callable(Global.game_controller.current_2d_scene, "_on_tower_menu_closed"))
	level_gui.add_child(tower_menu) # Enters the tree
	# Connects the other signals
	tower_menu.build_button.connect("pressed", Callable(self, "_on_build_button_pressed"))
	tower_menu.upgrade_button.connect("pressed", Callable(self, "_on_upgrade_button_pressed"))
	tower_menu.remove_button.connect("pressed", Callable(self, "_on_remove_button_pressed"))
	tower_menu.tower_stats_button.connect("pressed", Callable(self, "_on_tower_stats_button_pressed"))
	# Disable buttons (unique for this tower)
	if level > 0:
		tower_menu.build_button.disabled = true
		if not can_be_upgraded():
			tower_menu.upgrade_button.disabled = true
		if is_tower_stats_button_locked:
			tower_menu.tower_stats_button.disabled = true
		if is_remove_button_locked:
			tower_menu.remove_button.disabled = true
	else:
		tower_menu.tower_stats_button.disabled = true
		tower_menu.remove_button.disabled = true
		tower_menu.upgrade_button.disabled = true

func _on_touch_screen_button_pressed() -> void:
	SoundManager.click.play()
	if not level_gui.has_node("TowerMenu"):
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
	var tower_stats = tower_stats_scene.instantiate()
	tower_stats.menu_position = menu_position
	tower_stats.tower_position = position
	# Connects the "opened" and "closed" signals to the level
	tower_stats.connect("opened", Callable(Global.game_controller.current_2d_scene, "_on_tower_stats_opened"))
	tower_stats.connect("closed", Callable(Global.game_controller.current_2d_scene, "_on_tower_stats_closed"))
	level_gui.add_child(tower_stats) # Enters the tree
	tower_stats.values_label.text = str(
		unit_stats["level_" + str(level)]["attack_range"], "\n",
		unit_stats["level_" + str(level)]["damage"], "\n",
		unit_stats["level_" + str(level)]["count"], "\n",
		current_cost, "\n",
		min(MAX_LEVEL, PlayerStats.tower_level_limit)
	)
	close_menu()
	player_opened_tower_stats.emit()

func _on_level_1_player_ended_tutorial() -> void:
	# Enable the remove button if the menu is opened
	if tower_menu.visible:
		tower_menu.remove_button.disabled = false
