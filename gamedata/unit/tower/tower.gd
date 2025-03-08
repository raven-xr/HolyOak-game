extends Node2D



@export var smoke_preload: PackedScene



@onready var building = $SFX/Building
@onready var units = $Units
@onready var animation_player = $AnimationPlayer
@onready var gfx_smoke = $GFX/Smoke

@onready var unit_scene: PackedScene = get_parent().unit_scene
@onready var unit_stats: Dictionary = UnitData.get(unit_scene.instantiate().technical_name)
@onready var current_cost = unit_stats["level_1"]["cost"]



const MAX_LEVEL: int = 7



var tower_level_limit: int = PlayerStats.tower_level_limit
var level: int = 0:
	set(value):
		level = value
		upgrading()

var unit_count: int = 0
var unit_spawnpoints: Array

var is_upgrading: bool = false:
	set(value):
		is_upgrading = value
		if is_upgrading:
			upgrading_started.emit()
		else:
			upgrading_finished.emit()
var last_cost: int
var smoke_spawnpoints: Array = [
						 Vector2(32, 0), Vector2(-32, 0), Vector2(0, 32), Vector2(0, -32),
						 Vector2(32, 32), Vector2(-32, 32), Vector2(32, -32), Vector2(-32, -32)
						]



signal upgrading_started()
signal upgrading_finished()



# Common
func new_unit():
	var unit = unit_scene.instantiate()
	unit.position = unit_spawnpoints[units.get_child_count()]
	unit.level = level
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
	# Update data
	unit_count = unit_stats["level_" + str(level)]["unit_count"]
	unit_spawnpoints = unit_stats["level_" + str(level)]["spawnpoints"]
	
	last_cost = current_cost
	if level in [MAX_LEVEL, tower_level_limit]:
		current_cost = "-" # for tower stats
	else:
		current_cost = unit_stats["level_" + str(level + 1)]["cost"]
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
	PlayerStats.money += int(float(last_cost) / 2)
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
	tween_2.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	var tween_3 = get_tree().create_tween()
	tween_3.tween_property(get_parent().logo, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	await tween_2.finished
	await get_tree().create_timer(2.0).timeout
	# Make smokes stop repeating
	for smoke in gfx_smoke.get_children():
		smoke.is_active = false
	# Remove the tower
	is_upgrading = false
	queue_free()

func can_be_upgraded():
	if is_upgrading or level in [MAX_LEVEL, tower_level_limit]:
		return false
	else:
		return true

# AnimationPlayer
func hide_logo():
	get_parent().logo.modulate = Color(1.0, 1.0, 1.0, 0.0)
