extends Node2D

@export_subgroup("Required Scenes")
@export var unit_scene: PackedScene
@export var smoke_scene: PackedScene
@export var tower_menu_scene: PackedScene
@export var tower_stats_scene: PackedScene

@export_subgroup("Misc")
@export var menu_position: StringName = "D"
@export var default_view_direction: StringName = "D"

@onready var logo: Sprite2D = $Logo
@onready var units: Node2D = $Units
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton
@onready var sfx_building: AudioStreamPlayer2D = $Building
@onready var gfx_smoke: Node2D = $Smoke
@onready var attack_range: Area2D = $AttackRange
@onready var attack_range_col: CollisionShape2D = $AttackRange/CollisionShape2D

@onready var unit_stats: Dictionary[StringName, Dictionary] = UnitData.get(unit_scene.instantiate().technical_name)

# GUI of the current level
@onready var level_gui: Control = Global.game_controller.current_2d_scene.get_node("GUI")

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
var is_upgrading: bool = false

var tower_menu

func _ready() -> void:
	# Set the logo
	logo.texture = unit_scene.instantiate().logo

func _on_touch_screen_button_pressed() -> void:
	SoundManager.click.play()
	if tower_menu:
		close_menu()
	else:
		open_menu()

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
	# Disable buttons
	if level > 0:
		tower_menu.build_button.disabled = true
		if not can_be_upgraded():
			tower_menu.upgrade_button.disabled = true
	else:
		tower_menu.upgrade_button.disabled = true
		tower_menu.remove_button.disabled = true
		tower_menu.tower_stats_button.disabled = true

func close_menu() -> void:
	tower_menu.close()
	tower_menu = null

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
	close_menu()
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

func upgrade() -> void:
	# Remove the AttackRange
	attack_range_col.set_deferred("disabled", true)
	is_upgrading = true
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
	# Unless there is an opened TowerStats in the level GUI, enable the TouchScreenButton
	if not level_gui.has_node("TowerStats") and not level_gui.has_node("TowerMenu"):
		touch_screen_button.visible = true
	is_upgrading = false
	# Set the AttackRange
	attack_range_col.disabled = false
	attack_range_col.shape.radius = unit_stats["level_" + str(level)]["attack_range"]

func remove() -> void:
	# Remove the AttackRange
	attack_range_col.set_deferred("disabled", true)
	is_upgrading = true
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
	await animation_player.animation_finished
	# Unless there is an opened TowerStats or TowerMenu in the level GUI, enable the TouchScreenButton
	if not level_gui.has_node("TowerStats") and not level_gui.has_node("TowerMenu"):
		touch_screen_button.visible = true
	# Update current cost
	current_cost = unit_stats["level_1"]["cost"]
	is_upgrading = false

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
