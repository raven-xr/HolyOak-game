extends Node2D

const SPEED = 0.04

var health = 100

var ork_preload = preload("res://enemies/ork/enemy.tscn")

@onready var radio_idle = $SFX/RadioIdle
@onready var radio_fight = $SFX/RadioFight
@onready var path_2d = $Path/Path2D

func _ready():
	# Getting ready
	modulate = Color(0, 0, 0, 1)
	radio_idle.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_idle, "volume_db", -20, 4.0)
	# Debug
	await get_tree().create_timer(5.0).timeout
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
	# Add orks
	for i in range(3):
		var ork = ork_preload.instantiate()
		path_2d.add_child(ork)
		await get_tree().create_timer(1.5).timeout
