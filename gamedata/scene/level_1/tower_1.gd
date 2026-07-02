extends "res://gamedata/unit/common/tower.gd"

@onready var level_1: Level = $"../.."

signal player_opened_menu()
signal player_built_tower()
signal player_upgraded_tower()
signal player_opened_info()

var is_info_button_locked: bool = true
var is_remove_button_locked: bool = true

func open_menu() -> void:
	tower_menu = tower_menu_scene.instantiate()
	tower_menu.unit_name = unit_scene.instantiate().name
	tower_menu.menu_position = menu_position
	tower_menu.tower = self
	# Connects the "opened" and "closed" signals to the level
	tower_menu.connect("opened", Callable(Global.game_controller.current_2d_scene, "_on_tower_menu_opened"))
	tower_menu.connect("closed", Callable(Global.game_controller.current_2d_scene, "_on_tower_menu_closed"))
	global_gui.add_child(tower_menu) # Enters the tree
	# Connects the other signals
	tower_menu.build_button.connect("pressed", Callable(self, "_on_build_button_pressed"))
	tower_menu.upgrade_button.connect("pressed", Callable(self, "_on_upgrade_button_pressed"))
	tower_menu.remove_button.connect("pressed", Callable(self, "_on_remove_button_pressed"))
	tower_menu.info_button.connect("pressed", Callable(self, "_on_info_button_pressed"))
	# Disable buttons (unique for this tower)
	if level > 0:
		tower_menu.build_button.disabled = true
		if not can_be_upgraded():
			tower_menu.upgrade_button.disabled = true
		if is_info_button_locked:
			tower_menu.info_button.disabled = true
		if is_remove_button_locked:
			tower_menu.remove_button.disabled = true
	else:
		tower_menu.info_button.disabled = true
		tower_menu.remove_button.disabled = true
		tower_menu.upgrade_button.disabled = true

func _on_touch_button_pressed() -> void:
	SoundManager.click.play()
	if tower_menu:
		close_menu()
	else:
		open_menu()
	player_opened_menu.emit()

func _on_build_button_pressed() -> void:
	SoundManager.click.play()
	# Check whether player has enough money
	if Global.game_controller.current_2d_scene.money >= current_cost:
		upgrade()
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("У вас недостаточно монет. Текущая стоимость строительства — " + str(current_cost) + " монет")
	close_menu()
	player_built_tower.emit()

func _on_upgrade_button_pressed() -> void:
	SoundManager.click.play()
	# Check whether player has enough money
	if Global.game_controller.current_2d_scene.money >= current_cost:
		upgrade()
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("У вас недостаточно монет. Текущая стоимость улучшения — " + str(current_cost) + " монет")
	close_menu()
	player_upgraded_tower.emit()

func _on_info_button_pressed() -> void:
	SoundManager.click.play()
	close_menu()
	Global.game_controller.change_gui_scene("info_tab", false, true)
	var info_tab: NodeGUI = Global.game_controller.current_gui_scene
	var stats: Array[int] = [
		unit_stats["level_" + str(level)]["attack_range"],
		unit_stats["level_" + str(level)]["damage"],
		unit_stats["level_" + str(level)]["count"],
		level,
		min(MAX_LEVEL, Global.game_controller.current_2d_scene.tower_level_limit)
	]
	info_tab.set_text(unit_stats["description"] + "Урон — %d\nДальность атаки — %d\nКоличество юнитов — %d\nУровень — %d\nМакс. уровень — %d" % stats)
	player_opened_info.emit()

func _on_level_1_player_ended_tutorial() -> void:
	# Enable the remove button if the menu is opened
	if tower_menu.visible:
		tower_menu.remove_button.disabled = false
