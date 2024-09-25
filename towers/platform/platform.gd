extends Node2D

var is_menu_opened = false

@export var tower_preload: PackedScene
@export var tower_stats_preload: PackedScene
@export var message_preload: PackedScene
@export var default_direction: String = "U" # The default view direction of units: Up (U), Right (R), Down (D) or Left (L)

@onready var sprite_2d = $Sprite2D
@onready var menu = $Menu
@onready var towers = $Towers
@onready var build_texture_button = $"Menu/Build TextureButton"
@onready var upgrade_texture_button = $"Menu/Upgrade TextureButton"
@onready var remove_texture_button = $"Menu/Remove TextureButton"
@onready var tower_stats_texture_button = $"Menu/TowerStats TextureButton"
@onready var tower_stats = $TowerStats

func _ready():
	match default_direction:
		"U": menu.position = Vector2(0.0, -88.0)
		"R": menu.position = Vector2(144.0, 0.0)
		"D": menu.position = Vector2(0.0, 88.0)
		"L": menu.position = Vector2(-144.0, 0.0)
	for button in menu.get_children():
		button.disabled = true
	menu.modulate = Color(1, 1, 1, 0)

func _on_build_texture_button_pressed():
	SoundManager.click.play()
	var cost = UnitStats.archers['level_1']['cost']
	# Check if player has enough money
	if PlayerStats.money >= cost:
		var new_tower = tower_preload.instantiate()
		towers.add_child(new_tower)
		Signals.emit_signal("tower_built")
		new_tower.level += 1
		sprite_2d.visible = false
	else:
		var new_message = message_preload.instantiate()
		new_message.text = str("You don't have enough money on your balance sheet. The build cost is ", cost)
		add_child(new_message)
	close_menu()
	
func _on_upgrade_texture_button_pressed():
	SoundManager.click.play()
	var tower = towers.get_child(0)
	var cost = tower.current_cost
	# Check if player has enough money
	if PlayerStats.money >= cost:
		tower.level += 1
	else:
		var new_message = message_preload.instantiate()
		new_message.text = str("You don't have enough money on your balance sheet. The current upgrade cost is ", cost)
		add_child(new_message)
	close_menu()

func _on_remove_texture_button_pressed():
	SoundManager.click.play()
	tower_stats_texture_button.disabled = true
	var tower = towers.get_child(0)
	tower.destruction()
	Signals.emit_signal("tower_removed")
	sprite_2d.visible = true
	close_menu()

func _on_tower_stats_texture_button_pressed():
	SoundManager.click.play()
	var new_tower_stats = tower_stats_preload.instantiate()
	match default_direction:
		"U": new_tower_stats.position = Vector2(0.0, -144.0)
		"R": new_tower_stats.position = Vector2(192.0, 0.0)
		"D": new_tower_stats.position = Vector2(0.0, 144.0)
		"L": new_tower_stats.position = Vector2(-192.0, 0.0)
	tower_stats.add_child(new_tower_stats)
	close_menu()

func _on_touch_screen_button_pressed():
	SoundManager.click.play()
	if not is_menu_opened:
		open_menu()
	else:
		close_menu()
	
func close_menu():
	var tween = create_tween()
	tween.tween_property(menu, "modulate", Color(1, 1, 1, 0), 0.1)
	is_menu_opened = false
	for button in menu.get_children():
		button.disabled = true
	
func open_menu():
	var tween = create_tween()
	tween.tween_property(menu, "modulate", Color(1, 1, 1, 1), 0.1)
	is_menu_opened = true
	# Close tower stats
	if tower_stats.get_child_count() == 1:
		tower_stats.get_child(0).close()
	# Enable buttons
	if towers.get_child_count() == 0:
		build_texture_button.disabled = false
	else:
		var tower = towers.get_child(0)
		if not(tower.is_upgrading):
			if tower.level > 0:
				tower_stats_texture_button.disabled = false
			remove_texture_button.disabled = false
		if tower.can_be_upgraded():
			upgrade_texture_button.disabled = false
