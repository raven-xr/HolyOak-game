extends Node2D

var archers_build_cost = UnitStats.archers['level_1']['upgrade_cost']

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

@export var default_view_direction: String = "D" # The type of tower: Upper (U), Side (S) or Down (D)
@export var default_flip_h: bool = false # If the tower is side, then it needs to be flipped or not; basic off

func _ready():
	if default_view_direction == "D":
		menu.position = Vector2(0.0, 88.0)
	elif default_view_direction == "U":
		menu.position = Vector2(0.0, -88.0)
	elif default_view_direction == "S":
		if default_flip_h:
			menu.position = Vector2(88.0, 0.0)
		else:
			menu.position = Vector2(-88.0, 0.0)
	for button in menu.get_children():
		button.disabled = true
	menu.modulate = Color(1, 1, 1, 0)

func _on_build_texture_button_pressed():
	click_2d.play()
	# Check if player has enough money
	if PlayerStats.money >= archers_build_cost:
		var tower = tower_preload.instantiate()
		towers.add_child(tower)
		tower.level += 1
		sprite_2d.visible = false
	else:
		var message = message_preload.instantiate()
		message.text = str("You don't have enough money on your balance sheet. The build cost is ", archers_build_cost)
		message.width = len(message.text) * 10.0
		self.add_child(message)
	close_menu()
	
func _on_upgrade_texture_button_pressed():
	click_2d.play()
	# Check if player has enough money
	if PlayerStats.money >= UnitStats.archers['level_1']['upgrade_cost']:
		towers.get_child(0).level += 1
	else:
		var message = message_preload.instantiate()
		message.text = str("You don't have enough money on your balance sheet. The current upgrade cost is ", archers_build_cost)
		message.width = len(message.text) * 10.0
		self.add_child(message)
	close_menu()

func _on_remove_texture_button_pressed():
	click_2d.play()
	towers.get_child(0).destruction()
	await get_tree().create_timer(1.0).timeout
	sprite_2d.visible = true
	close_menu()

func _on_stats_texture_button_pressed():
	click_2d.play()
	var stats = stats_preload.instantiate()
	stats.position = Vector2(-132.0, -217.0)
	stats.text = "Attack Range\nDamage\nUnits\nUpgrade Cost"
	self.add_child(stats)
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
		if towers.get_child(0).level > 0:
			stats_texture_button.disabled = false
		if not(towers.get_child(0).is_upgrading):
			remove_texture_button.disabled = false
		if towers.get_child(0).can_be_upgraded():
			upgrade_texture_button.disabled = false
