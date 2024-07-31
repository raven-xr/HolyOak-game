extends Node2D

var is_menu_opened = false
var tower_preload = preload("res://scenes/units/archers/tower.tscn")

@onready var sprite_2d = $Sprite2D
@onready var click_2d = $SFX/Click2D
@onready var menu = $Menu
@onready var towers = $Towers
@onready var build_texture_button = $Menu/BuildTextureButton
@onready var upgrade_texture_button = $Menu/UpgradeTextureButton
@onready var remove_texture_button = $Menu/RemoveTextureButton

@export var default_view_direction: String = "D" # The type of tower: Upper (U), Side (S) or Down (D)
@export var default_flip_h: bool = false # If the tower is side, then it needs to be flipped or not; basic off

func _ready():
	close_menu()

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

func _on_touch_screen_button_pressed():
	click_2d.play()
	if not is_menu_opened:
		show_menu()
	else:
		close_menu()
	
func close_menu():
	menu.visible = false
	is_menu_opened = false
	for child in menu.get_children():
		child.disabled = true
	
func show_menu():
	menu.visible = true
	is_menu_opened = true
	if towers.get_child_count() == 0:
		build_texture_button.disabled = false
	else:
		if not(towers.get_child(0).is_upgrading):
			remove_texture_button.disabled = false
		if towers.get_child(0).can_be_upgraded():
			upgrade_texture_button.disabled = false
