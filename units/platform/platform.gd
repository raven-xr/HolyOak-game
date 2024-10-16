extends Node2D

@export var tower_preload: PackedScene
@export var tower_stats_preload: PackedScene
@export var message_preload: PackedScene
@export var default_direction: String = "U" # The default view direction of units: Up (U), Right (R), Down (D) or Left (L)

@onready var sprite_2d = $Sprite2D
@onready var touch_screen_button = $TouchScreenButton
@onready var menu = $Menu

@onready var build_button = $"Menu/Build Button"
@onready var upgrade_button = $"Menu/Upgrade Button"
@onready var remove_button = $"Menu/Remove Button"
@onready var tower_stats_button = $"Menu/TowerStats Button"

func _ready():
	match default_direction:
		"U": menu.position = Vector2(0.0, -88.0)
		"R": menu.position = Vector2(164.0, 0.0)
		"D": menu.position = Vector2(0.0, 88.0)
		"L": menu.position = Vector2(-164.0, 0.0)
	menu.modulate = Color(1, 1, 1, 0)
	menu.visible = false

func _on_build_button_pressed():
	SoundManager.click.play()
	var cost = UnitStats.archers["level_1"]["cost"]
	# Check if player has enough money
	if PlayerStats.money >= cost:
		var new_tower = tower_preload.instantiate()
		add_child(new_tower)
		new_tower.connect("upgrading_started", Callable(self, "_on_upgrading_started"))
		new_tower.connect("upgrading_finished", Callable(self, "_on_upgrading_finished"))
		move_child(new_tower, 2)
		new_tower.level += 1
		sprite_2d.visible = false
	else:
		var new_message = message_preload.instantiate()
		new_message.text = "У вас недостаточно монет. Текущая стоимость башни - " + str(cost) + " монет"
		add_child(new_message)
	close_menu()
	
func _on_upgrade_button_pressed():
	SoundManager.click.play()
	var tower = get_node("Tower")
	var cost = tower.current_cost
	# Check if player has enough money
	if PlayerStats.money >= cost:
		tower.level += 1
	else:
		var new_message = message_preload.instantiate()
		new_message.text = "У вас недостаточно монет. Текущая стоимость улучшения - " + str(cost) + " монет"
		add_child(new_message)
	close_menu()

func _on_remove_button_pressed():
	SoundManager.click.play()
	var tower = get_node("Tower")
	tower.disconnect("upgrading_started", Callable(self, "_on_upgrading_started"))
	tower.disconnect("upgrading_finished", Callable(self, "_on_upgrading_finished"))
	tower.destruction()
	sprite_2d.visible = true
	close_menu()

func _on_tower_stats_button_pressed():
	SoundManager.click.play()
	var new_tower_stats = tower_stats_preload.instantiate()
	match default_direction:
		"U": new_tower_stats.position = Vector2(0.0, -144.0)
		"R": new_tower_stats.position = Vector2(192.0, 0.0)
		"D": new_tower_stats.position = Vector2(0.0, 144.0)
		"L": new_tower_stats.position = Vector2(-192.0, 0.0)
	add_child(new_tower_stats)
	close_menu()

func _on_touch_screen_button_pressed():
	SoundManager.click.play()
	if not menu.visible:
		open_menu()
	else:
		close_menu()

func open_menu():
	menu.visible = true
	var tween = create_tween()
	tween.tween_property(menu, "modulate", Color(1, 1, 1, 1), 0.1)
	# Close tower stats
	if has_node("TowerStats"):
		var tower_stats = get_node("TowerStats")
		tower_stats.close()
	# Disable buttons
	if has_node("Tower"):
		build_button.disabled = true
		if not get_node("Tower").can_be_upgraded():
			upgrade_button.disabled = true
	else:
		upgrade_button.disabled = true
		remove_button.disabled = true
		tower_stats_button.disabled = true

func close_menu():
	var tween = create_tween()
	tween.tween_property(menu, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	menu.visible = false
	for button in menu.get_children():
		button.disabled = false
	
func _on_upgrading_started():
	touch_screen_button.visible = false

func _on_upgrading_finished():
	touch_screen_button.visible = true
