extends Node2D

var free = true

@onready var click_2d = $SFX/Click2D
@onready var menu = $Menu
@onready var towers = $Towers
@onready var build_texture_button = $Menu/BuildTextureButton
@onready var upgrade_texture_button = $Menu/UpgradeTextureButton
@onready var tower_preload = preload("res://scenes/units/archers/tower.tscn")

func _ready():
	hide_menu()

func _on_build_texture_button_pressed():
	click_2d.play()
	var tower = tower_preload.instantiate()
	towers.add_child(tower)
	#Stats.money -= tower.BUILD_COST
	free = false
	hide_menu()
	
func _on_upgrade_texture_button_pressed():
	click_2d.play()
	towers.get_child(0).level += 1
	# towers.get_child(0) is a tower
	hide_menu()

func _on_touch_screen_button_pressed():
	click_2d.play()
	menu.visible = true
	if free:
		build_texture_button.disabled = false
	elif towers.get_child(0).level >= 1:
		# towers.get_child(0) is a tower
		upgrade_texture_button.disabled = false

func hide_menu():
	menu.visible = false
	for child in menu.get_children():
		child.disabled = true
