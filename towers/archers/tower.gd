extends Node2D

var max_level = PlayerStats.max_level
var level = 0:
	set(value):
		level = value
		upgrading()
var is_upgrading = false
var damage = 0
var attack_range = 10 # Default collision shape's radius
var current_cost = UnitStats.archers['level_1']['cost']
var last_cost
var unit_count = 0
var spawnpoints = []
var smoke_spawnpoints = [Vector2(32, 0), Vector2(-32, 0), Vector2(0, 32), Vector2(0, -32),
						 Vector2(32, 32), Vector2(-32, 32), Vector2(32, -32), Vector2(-32, -32)]
var unit_preload = preload("res://towers/archers/archer.tscn")
var smoke_preload = preload("res://effects/smoke/smoke.tscn")

@onready var units = $Units
@onready var animation_player = $AnimationPlayer
@onready var gfx_smoke = $GFX/Smoke
@onready var success_2d = $SFX/Success2D
@onready var building_2d = $SFX/Building2D

func new_unit():
	var unit = unit_preload.instantiate()
	unit.position = spawnpoints[units.get_child_count()]
	units.add_child(unit)
	var tween = get_tree().create_tween()
	tween.tween_property(units, "modulate", Color(1, 1, 1, 1), 0.15)

func upgrading():
	# Inform the platform that the tower is being upgraded
	is_upgrading = true
	# Take money away from the player
	PlayerStats.money -= current_cost
	# Remove units
	var tween = get_tree().create_tween()
	tween.tween_property(units, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	for child in units.get_children():
		child.queue_free()
	# Upgrade stats
	damage = UnitStats.archers[str('level_', level)]['damage']
	last_cost = current_cost
	current_cost = UnitStats.archers[str('level_', level+1)]['cost']
	unit_count = UnitStats.archers[str('level_', level)]['unit_count']
	spawnpoints = UnitStats.archers[str('level_', level)]['spawnpoints']
	attack_range = UnitStats.archers[str('level_', level)]['attack_range']
	# Play animation, SFX and GFX
	animation_player.play(str("Level_", level))
	building_2d.play()
	await animation_player.animation_finished
	success_2d.play()
	# Add new units
	for i in range(unit_count):
		new_unit()
	# Inform the platform that the tower finsihed upgrading
	is_upgrading = false
	# If the platform interface is opened, then enable remove button
	get_parent().get_parent().remove_texture_button.disabled = false
	# If the platform interface is opened, then enable upgrade button
	if max_level != level:
		get_parent().get_parent().upgrade_texture_button.disabled = false

func destruction():
	# Inform the platform that the tower is being destructed
	is_upgrading = true
	# Refund 50% of the last cost
	PlayerStats.money += last_cost * 0.5
	# Remove units
	var tween_1 = get_tree().create_tween()
	tween_1.tween_property(units, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween_1.finished
	for child in units.get_children():
		child.queue_free()
	# Play animation, SFX and GFX
	building_2d.play()
	# Spawn 4 smokes
	for i in range(4):
		var new_smoke = smoke_preload.instantiate()
		new_smoke.position = smoke_spawnpoints[gfx_smoke.get_child_count()-1]
		gfx_smoke.add_child(new_smoke)
	# Waiting for 0.7 seconds to desynchronize smokes
	await get_tree().create_timer(0.7).timeout
	# Spawn 4 smokes more
	for i in range(4): 
		var new_smoke = smoke_preload.instantiate()
		new_smoke.position = smoke_spawnpoints[gfx_smoke.get_child_count()-1]
		gfx_smoke.add_child(new_smoke)
	# Hide the tower
	var tween_2 = get_tree().create_tween()
	tween_2.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0) # 3.0 - 2.0
	await tween_2.finished
	await get_tree().create_timer(2.0).timeout # that same 2.0
	success_2d.play()
	# Make smokes stop repeating
	for child in gfx_smoke.get_children():
		child.is_active = false
	# If the platform interface is opened, then enable build button
	get_parent().get_parent().build_texture_button.disabled = false
	# If the platform interface is opened, then disable build button
	get_parent().get_parent().stats_texture_button.disabled = true
	# Remove the tower
	queue_free()

func can_be_upgraded():
	if is_upgrading or max_level == level:
		return false
	else:
		return true
