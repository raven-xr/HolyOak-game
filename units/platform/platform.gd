extends Node2D

var is_menu_opened = false
var tower_preload = preload("res://units/archers/tower.tscn")
var stats_preload = preload("res://subscenes/stats/stats.tscn")
var message_preload = preload("res://subscenes/message/message.tscn")

@onready var sprite_2d = $Sprite2D
@onready var click_2d = $SFX/Click2D
@onready var menu = $Menu
@onready var towers = $Towers
@onready var build_texture_button = $Menu/BuildTextureButton
@onready var upgrade_texture_button = $Menu/UpgradeTextureButton
@onready var remove_texture_button = $Menu/RemoveTextureButton
@onready var stats_texture_button = $Menu/StatsTextureButton

@export var default_direction: String = "D" # The default view direction of units: Upper (U), Side (S) or Down (D)
@export var default_flip_h: bool = false # If the tower is side, then it needs to be flipped or not; basic off

func _ready():
	if default_direction == "D":
		menu.position = Vector2(0.0, 88.0)
	elif default_direction == "U":
		menu.position = Vector2(0.0, -88.0)
	elif default_direction == "S":
		if default_flip_h:
			menu.position = Vector2(144.0, 0.0)
		else:
			menu.position = Vector2(-144.0, 0.0)
	for button in menu.get_children():
		button.disabled = true
	menu.modulate = Color(1, 1, 1, 0)

func _on_build_texture_button_pressed():
	click_2d.play()
	var cost = UnitStats.archers['level_1']['cost']
	# Check if player has enough money
	if PlayerStats.money >= cost:
		var new_tower = tower_preload.instantiate()
		towers.add_child(new_tower)
		new_tower.level += 1
		sprite_2d.visible = false
	else:
		var new_message = message_preload.instantiate()
		new_message.text = str("You don't have enough money on your balance sheet. The build cost is ", cost)
		add_child(new_message)
	close_menu()
	
func _on_upgrade_texture_button_pressed():
	click_2d.play()
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
	click_2d.play()
	var tower = towers.get_child(0)
	tower.destruction()
	sprite_2d.visible = true
	close_menu()

func _on_stats_texture_button_pressed():
	click_2d.play()
	var new_stats = stats_preload.instantiate()
	if default_direction == "D":
		new_stats.position = Vector2(0.0, 144.0)
	elif default_direction == "U":
		new_stats.position = Vector2(0.0, -144.0)
	elif default_direction == "S":
		if default_flip_h:
			new_stats.position = Vector2(192.0, 0.0)
		else:
			new_stats.position = Vector2(-192.0, 0.0)
	new_stats.text = "Attack Range\nDamage\nUnits\nUpgrade Cost"
	add_child(new_stats)
	close_menu()

func _on_touch_screen_button_pressed():
	click_2d.play()
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
	if towers.get_child_count() == 0:
		build_texture_button.disabled = false
	else:
		var tower = towers.get_child(0)
		if tower.level > 0:
			stats_texture_button.disabled = false
		if not(tower.is_upgrading):
			remove_texture_button.disabled = false
		if tower.can_be_upgraded():
			upgrade_texture_button.disabled = false
