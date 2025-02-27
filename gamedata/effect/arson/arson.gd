extends Node2D

@export var technical_name: StringName

@onready var timer = $Timer
@onready var enemy: Enemy = get_parent()
@onready var stats: Dictionary = EffectData.get(technical_name)
@onready var damage: int = stats["damage"]
@onready var duration: int = stats["duration"]
@onready var target_damage: int = damage * duration

var total_damage: int = 0

func _ready():
	enemy.future_health -= target_damage

func _on_timer_timeout():
	enemy.health -= damage
	total_damage += damage
	# If effect damaged enough then remove it
	if total_damage == target_damage:
		queue_free()
	else:
		timer.start()
