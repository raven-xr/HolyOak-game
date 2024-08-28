extends Node2D

const SPEED = 0.04

var wave = 0:
	set(value):
		wave = value
		match wave:
			1: wave_1()
			2: wave_2()
			3: wave_3()
var ork_preload = preload("res://enemies/ork/enemy.tscn")

@onready var radio_idle = $SFX/RadioIdle
@onready var radio_fight = $SFX/RadioFight
@onready var enemies = $Enemies
@onready var trees = $Objects/Trees
@onready var bushes = $Objects/Bushes

func _ready():
	# Update PlayerStats
	PlayerStats.money = 200
	PlayerStats.max_level = 3
	# Getting ready
	modulate = Color(0, 0, 0, 1)
	radio_idle.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_idle, "volume_db", -20, 4.0)
	for tree in trees.get_children():
		var size = randf_range(1.4, 1.6)
		tree.scale = Vector2(size, size)
	for bush in bushes.get_children():
		var size = randf_range(0.8, 1.1)
		bush.scale = Vector2(size, size)
	# Start the fighting
	await get_tree().create_timer(10.0).timeout
	fight()

func fight():
	# Getting ready
	radio_fight.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(radio_idle, "volume_db", -100, 4.0)
	tween_1.connect("finished", radio_idle.stop)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_fight, "volume_db", -20, 4.0)
	# Fight
	wave += 1

func wave_1():
	pass
	
func wave_2():
	pass
	
func wave_3():
	pass
