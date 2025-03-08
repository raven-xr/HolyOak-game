extends Node2D

@export_subgroup("Required scenes")
@export var tower_scene: PackedScene
@export var tower_stats_scene: PackedScene
@export var message_scene: PackedScene
@export_subgroup("Unit")
@export var unit_scene: PackedScene
@export var unit_logo: Texture
## The character's logo is displayed on the platform's sprite plate.
@export var default_view_direction: String = "D"

@onready var sprite_2d = $Sprite2D
@onready var touch_screen_button = $TouchScreenButton
@onready var menu = $Menu
@onready var unit_name = $"Unit Name"
@onready var logo = $Logo

@onready var build_button = $"Menu/Build Button"
@onready var upgrade_button = $"Menu/Upgrade Button"
@onready var remove_button = $"Menu/Remove Button"
@onready var tower_stats_button = $"Menu/Tower Stats Button"

# Common
func _ready():
	# Scale the menu
	# Square the scale to reach the best view
	menu.scale = Vector2(UserSettings.gui_scale**2, UserSettings.gui_scale**2)
	# Posite the menu
	match default_view_direction:
		"U": menu.position = Vector2(-128.0, -160.0); menu.pivot_offset = Vector2(128.0, 128.0)
		"R": menu.position = Vector2(40.0, -64.0); menu.pivot_offset = Vector2(0.0, 64.0)
		"D": menu.position = Vector2(-128.0, 40.0); menu.pivot_offset = Vector2(128.0, 0.0)
		"L": menu.position = Vector2(-296.0, -64.0); menu.pivot_offset = Vector2(256.0, 64.0)
	# Set the logo
	logo.texture = unit_logo

func open_menu():
	menu.visible = true
	unit_name.visible = true
	var tween_1 = create_tween()
	tween_1.tween_property(menu, "modulate", Color(1, 1, 1, 1), 0.1)
	var tween_2 = create_tween()
	tween_2.tween_property(unit_name, "modulate", Color(1, 1, 1, 1), 0.1)
	# Close tower stats
	if has_node("Tower Stats"):
		var tower_stats = get_node("Tower Stats")
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
	unit_name.text = unit_scene.instantiate().name
	

func close_menu():
	var tween_1 = create_tween()
	tween_1.tween_property(menu, "modulate", Color(1, 1, 1, 0), 0.1)
	var tween_2 = create_tween()
	tween_2.tween_property(unit_name, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween_1.finished
	menu.visible = false
	unit_name.visible = false
	for button in menu.get_children():
		button.disabled = false

func _on_upgrading_started():
	touch_screen_button.visible = false

func _on_upgrading_finished():
	touch_screen_button.visible = true

# Build Button
func _on_build_button_pressed():
	SoundManager.click.play()
	# Get the cost of the tower
	var cost = UnitData.get(unit_scene.instantiate().technical_name)["level_1"]["cost"]
	# Check if player has enough money
	if PlayerStats.money >= cost:
		var new_tower = tower_scene.instantiate()
		add_child(new_tower)
		new_tower.connect("upgrading_started", Callable(self, "_on_upgrading_started"))
		new_tower.connect("upgrading_finished", Callable(self, "_on_upgrading_finished"))
		move_child(new_tower, 2)
		new_tower.level += 1
		sprite_2d.visible = false
	else:
		var new_message = message_scene.instantiate()
		new_message.text = "У вас недостаточно монет. Текущая стоимость башни - " + str(cost) + " монет"
		add_child(new_message)
	close_menu()



# Upgrade Button's functions
func _on_upgrade_button_pressed():
	SoundManager.click.play()
	var tower = get_node("Tower")
	var cost = tower.current_cost
	# Check if player has enough money
	if PlayerStats.money >= cost:
		tower.level += 1
	else:
		var new_message = message_scene.instantiate()
		new_message.text = "У вас недостаточно монет. Текущая стоимость улучшения - " + str(cost) + " монет"
		add_child(new_message)
	close_menu()



# Remove Button's functions
func _on_remove_button_pressed():
	SoundManager.click.play()
	var tower = get_node("Tower")
	tower.destruction()
	sprite_2d.visible = true
	close_menu()



# Tower Stats Button
func _on_tower_stats_button_pressed():
	SoundManager.click.play()
	var tower = get_node("Tower")
	var new_tower_stats = tower_stats_scene.instantiate()
	var positions = {
		"U": {"position": Vector2(-132, -263), "pivot_offset": Vector2(130, 202)},
		"R": {"position": Vector2(61, -101), "pivot_offset": Vector2(10, 101)},
		"D": {"position": Vector2(-132, 61), "pivot_offset": Vector2(130, 0)},
		"L": {"position": Vector2(-321, -101), "pivot_offset": Vector2(260, 101)}
	}
	new_tower_stats.values = str(
		tower.unit_stats["level_" + str(tower.level)]["attack_range"], "\n",
		tower.unit_stats["level_" + str(tower.level)]["damage"], "\n",
		tower.unit_stats["level_" + str(tower.level)]["unit_count"], "\n",
		tower.current_cost, "\n",
		tower.tower_level_limit
	)
	new_tower_stats.position = positions[default_view_direction]["position"]
	new_tower_stats.pivot_offset = positions[default_view_direction]["pivot_offset"]
	add_child(new_tower_stats)
	close_menu()



# Touch Screen Button
func _on_touch_screen_button_pressed():
	SoundManager.click.play()
	if not menu.visible:
		open_menu()
	else:
		close_menu()
