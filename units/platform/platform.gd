extends Node2D

var is_menu_opened = false
var tower_preload = preload("res://units/archers/tower.tscn")
var platform_stats_preload = preload("res://units/platform/platform_stats.tscn")

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
	for button in menu.get_children():
		button.disabled = true
	menu.modulate = Color(1, 1, 1, 0)

func _on_build_texture_button_pressed():
	click_2d.play()
	var tower = tower_preload.instantiate()
	towers.add_child(tower)
	sprite_2d.visible = false
	close_menu()
	
func _on_upgrade_texture_button_pressed():
	click_2d.play()
	towers.get_child(0).level += 1
	close_menu()

func _on_remove_texture_button_pressed():
	click_2d.play()
	towers.get_child(0).destruction()
	await get_tree().create_timer(1.0).timeout
	sprite_2d.visible = true
	close_menu()

func _on_stats_texture_button_pressed():
	click_2d.play()
	var platform_stats = platform_stats_preload.instantiate()
	platform_stats.position = Vector2(-132.0, -217.0)
	self.add_child(platform_stats)
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
