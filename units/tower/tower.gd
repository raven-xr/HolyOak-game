extends Node2D

@export var unit_preload: PackedScene
@export var smoke_preload: PackedScene

@onready var building = $SFX/Building
@onready var units = $Units
@onready var animation_player = $AnimationPlayer
@onready var gfx_smoke = $GFX/Smoke
@onready var platform = get_parent()

var max_level = PlayerStats.max_level
var level = 0:
	set(value):
		level = value
		upgrading()
var is_upgrading: bool = false:
	set(value):
		is_upgrading = value
		if is_upgrading:
			emit_signal("upgrading_started")
		else:
			emit_signal("upgrading_finished")
var damage = 0
var attack_range = 10 # Default collision shape"s radius
var current_cost = UnitStats.archers["level_1"]["cost"]
var last_cost = 0
var unit_count = 0
var spawnpoints = []
var smoke_spawnpoints = [Vector2(32, 0), Vector2(-32, 0), Vector2(0, 32), Vector2(0, -32),
						 Vector2(32, 32), Vector2(-32, 32), Vector2(32, -32), Vector2(-32, -32)]

@warning_ignore("unused_signal")
signal upgrading_started()
@warning_ignore("unused_signal")
signal upgrading_finished()

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
	for unit in units.get_children():
		unit.queue_free()
	# Upgrade stats
	damage = UnitStats.archers[str("level_", level)]["damage"]
	last_cost = current_cost
	current_cost = UnitStats.archers[str("level_", level+1)]["cost"]
	unit_count = UnitStats.archers[str("level_", level)]["unit_count"]
	spawnpoints = UnitStats.archers[str("level_", level)]["spawnpoints"]
	attack_range = UnitStats.archers[str("level_", level)]["attack_range"]
	# Play animation, SFX and GFX
	animation_player.play(str("Level_", level))
	building.play()
	await animation_player.animation_finished
	SoundManager.success.play()
	# Add new units
	for i in range(unit_count):
		new_unit()
	# Inform the platform that the tower finsihed upgrading
	is_upgrading = false

func destruction():
	# Inform the platform that the tower is being destructed
	is_upgrading = true
	# Refund 50% of the last cost
	PlayerStats.money += last_cost * 0.5
	# Remove units
	var tween_1 = get_tree().create_tween()
	tween_1.tween_property(units, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween_1.finished
	for unit in units.get_children():
		unit.queue_free()
	# Play animation, SFX and GFX
	building.play()
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
	tween_2.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0)
	await tween_2.finished
	await get_tree().create_timer(2.0).timeout
	# Make smokes stop repeating
	for smoke in gfx_smoke.get_children():
		smoke.is_active = false
	# Remove the tower
	queue_free()

func can_be_upgraded():
	if is_upgrading or max_level == level:
		return false
	else:
		return true
