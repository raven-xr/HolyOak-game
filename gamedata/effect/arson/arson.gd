extends Node2D
class_name Effect

@export var technical_name: StringName

@onready var timer: Timer = $Timer
@onready var enemy: Enemy = get_parent().get_parent()
@onready var stats: Dictionary = EffectData.get(technical_name)
@onready var damage: int = stats["damage"]
@onready var duration: int = stats["duration"]
@onready var target_damage: int = damage * duration

var total_damage: int = 0

func _ready():
	enemy.future_health -= target_damage

func _on_timer_timeout():
	total_damage += damage
	if total_damage == target_damage:
		expire()
	enemy.health -= damage

func expire():
	timer.stop()
	# w.i.p.
	visible = false
