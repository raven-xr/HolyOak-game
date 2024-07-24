extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var click_2d = $SFX/Click2D
@onready var menu = $Menu
@onready var towers = $Towers
@onready var build_texture_button = $Menu/BuildTextureButton
@onready var upgrade_texture_button = $Menu/UpgradeTextureButton
@onready var tower_preload = preload("res://scenes/units/archers/tower.tscn")

@export var default_view_direction: String = "D" # The type of tower: Upper (U), Side (S) or Down (D)
@export var default_flip_h: bool = false # If the tower is side, then it needs to be flipped or not; basic off

func _ready():
	hide_menu()

func _on_build_texture_button_pressed():
	click_2d.play()
	var tower = tower_preload.instantiate()
	towers.add_child(tower)
	sprite_2d.visible = false
	hide_menu()
	
func _on_upgrade_texture_button_pressed():
	click_2d.play()
	towers.get_child(0).level += 1
	# towers.get_child(0) is a tower
	hide_menu()

func _on_touch_screen_button_pressed():
	click_2d.play()
	menu.visible = true
	if towers.get_child_count() == 0:
		build_texture_button.disabled = false
	elif towers.get_child(0).can_be_upgraded():
		upgrade_texture_button.disabled = false

func hide_menu():
	menu.visible = false
	for child in menu.get_children():
		child.disabled = true
