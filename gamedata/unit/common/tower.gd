extends Node2D

@export_subgroup("Required Scenes")
@export var unit_scene: PackedScene
@export var smoke_scene: PackedScene
@export var message_scene: PackedScene

@export_subgroup("Misc")
@export var menu_position: StringName = "D"
@export var default_view_direction: StringName = "D"

@onready var logo: Sprite2D = $Logo
@onready var units: Node2D = $Units
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var menu: Control = $Interface/Menu
@onready var build_button: TextureButton = $"Interface/Menu/Build Button"
@onready var upgrade_button: TextureButton  = $"Interface/Menu/Upgrade Button"
@onready var remove_button: TextureButton  = $"Interface/Menu/Remove Button"
@onready var tower_stats_button: TextureButton  = $"Interface/Menu/Tower Stats Button"
@onready var unit_name: Label = $"Interface/Unit Name"
@onready var tower_stats: Control = $"Interface/Tower Stats"
@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton

@onready var sfx_building: AudioStreamPlayer2D = $Building
@onready var gfx_smoke: Node2D = $Smoke
@onready var unit_stats: Dictionary[StringName, Dictionary] = UnitData.get(unit_scene.instantiate().technical_name)

const MAX_LEVEL: int = 7
var level: int = 0
var unit_count: int = 0
var unit_spawnpoints: Array 

## Not always integer, when level equals MAX_LEVEL, it becomes the "-" string to
## show player he can't upgrade the tower anymore.
@onready var current_cost = unit_stats["level_1"]["cost"]
## Used to give half of the money back player
## spent on the last upgrade after the pressing Remove Button.
var last_cost: int = 0



func _ready() -> void:
	# Scale the interface and raise the scaling to the power of 1.5 to make it look better
	menu.scale = Vector2(UserSettings.gui_scale**1.5, UserSettings.gui_scale**1.5)
	# Posite the menu
	match menu_position:
		"U":
			menu.position = global_position + Vector2(-128.0, -160.0)
			menu.pivot_offset = Vector2(128.0, 128.0)
		"R":
			menu.position = global_position + Vector2(40.0, -64.0)
			menu.pivot_offset = Vector2(0.0, 64.0)
		"D":
			menu.position = global_position + Vector2(-128.0, 40.0)
			menu.pivot_offset = Vector2(128.0, 0.0)
		"L":
			menu.position = global_position + Vector2(-296.0, -64.0)
			menu.pivot_offset = Vector2(256.0, 64.0)
	# Set the logo
	logo.texture = unit_scene.instantiate().logo
	unit_name.text = unit_scene.instantiate().name



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
	# Disable buttons
	if level > 0:
		build_button.disabled = true
		if not can_be_upgraded():
			upgrade_button.disabled = true
	else:
		upgrade_button.disabled = true
		remove_button.disabled = true
		tower_stats_button.disabled = true

func close_menu() -> void:
	# Smooth disappearance
	var tween_1 = create_tween()
	tween_1.tween_property(menu, "modulate", Color(1, 1, 1, 0), 0.1)
	var tween_2 = create_tween()
	tween_2.tween_property(unit_name, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween_1.finished
	menu.visible = false
	unit_name.visible = false
	# Enable all buttons to disable them after the opening
	for button in menu.get_children():
		button.disabled = false

func _on_touch_screen_button_pressed() -> void:
	SoundManager.click.play()
	if not menu.visible:
		open_menu()
	else:
		close_menu()

func _on_build_button_pressed() -> void:
	SoundManager.click.play()
	# Check whether player has enough money
	if PlayerStats.money >= current_cost:
		upgrade()
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("У вас недостаточно монет. Текущая стоимость строительства — " + str(current_cost) + " монет")
	close_menu()

func _on_upgrade_button_pressed() -> void:
	SoundManager.click.play()
	# Check whether player has enough money
	if PlayerStats.money >= current_cost:
		upgrade()
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("У вас недостаточно монет. Текущая стоимость улучшения — " + str(current_cost) + " монет")
	close_menu()

func _on_remove_button_pressed() -> void:
	SoundManager.click.play()
	remove()
	close_menu()

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
		min(MAX_LEVEL, PlayerStats.tower_level_limit)
	)
	tower_stats.position = global_position + POSITIONS[menu_position]["position"]
	tower_stats.pivot_offset = POSITIONS[menu_position]["pivot_offset"]
	tower_stats.open()
	close_menu()

func upgrade() -> void:
	remove_units()
	# Block touch screen button to not let player interact with the interface
	touch_screen_button.visible = false
	level += 1
	# Update stats
	unit_count = unit_stats["level_" + str(level)]["count"]
	unit_spawnpoints = unit_stats["level_" + str(level)]["spawnpoints"]
	# Take away money from player
	PlayerStats.money -= current_cost
	# Update cost
	last_cost = current_cost
	if not can_be_upgraded():
		current_cost = "—"
	else:
		current_cost = unit_stats["level_" + str(level + 1)]["cost"]
	# Play animation, SFX and GFX
	animation_player.play("Level_" + str(level) + "_Upgrade") # level - 1 because it was increase before
	sfx_building.play()
	await animation_player.animation_finished
	SoundManager.success.play()
	# Create units
	spawn_units(unit_count, unit_spawnpoints)
	# Unblock touch screen button
	touch_screen_button.visible = true

func remove() -> void:
	remove_units()
	# Block touch screen button to not let player interact with the interface
	touch_screen_button.visible = false
	level = 0
	# Give half of the money back player spent last time
	PlayerStats.money += int(float(last_cost) / 2)
	# Play animation, SFX, GFX
	sfx_building.play()
	animation_player.play("Destruct")
	# Unblock touch screen button
	touch_screen_button.visible = true

func spawn_units(count: int, spawnpoints: Array) -> void:
	# Spawn units
	for i in range(count):
		var unit: Unit = unit_scene.instantiate()
		unit.position = spawnpoints[i]
		unit.level = level
		units.add_child(unit)
	# Smooth appearance
	var tween = create_tween()
	tween.tween_property(units, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)

func remove_units() -> void:
	# Smooth disappearance of units
	var tween = create_tween()
	tween.tween_property(units, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	# Free units
	for unit: Unit in units.get_children():
		unit.queue_free()

func spawn_smoke(count: int, spawnpoints: Array) -> void:
	for i in range(count):
		var smoke: AnimatedSprite2D = smoke_scene.instantiate()
		smoke.position = spawnpoints[i]
		gfx_smoke.add_child(smoke)

func remove_smoke() -> void:
	for smoke: AnimatedSprite2D in gfx_smoke.get_children():
		smoke.is_active = false

func can_be_upgraded() -> bool:
	if level in [MAX_LEVEL, PlayerStats.tower_level_limit]:
		return false
	return true
