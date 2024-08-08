extends Node2D

@onready var radio_idle = $SFX/RadioIdle
@onready var radio_fight = $SFX/RadioFight

func _ready():
	modulate = Color(0, 0, 0, 1)
	radio_idle.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_idle, "volume_db", -20, 4.0)

func fight():
	radio_fight.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(radio_idle, "volume_db", -100, 4.0)
	tween_1.connect("finished", radio_idle.stop)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_fight, "volume_db", -20, 4.0)
