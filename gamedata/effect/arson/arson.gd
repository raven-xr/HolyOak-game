extends Node2D
class_name Effect

@export var technical_name: StringName

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

@onready var enemy: Enemy = get_parent().get_parent()
@onready var stats: Dictionary = EffectData.get(technical_name)
@onready var damage: int = stats["damage"]
@onready var duration: int = stats["duration"]
@onready var target_damage: int = damage * duration

var total_damage: int = 0

func _ready():
	enemy.connect("died", Callable(self, "_on_enemy_died"))
	enemy.future_health -= target_damage

func _on_timer_timeout():
	total_damage += damage
	if total_damage == target_damage or enemy.health - damage <= 0:
		timer.stop()
		animation_player.play("Expire")
		await animation_player.animation_finished
		damage_enemy()
		queue_free()
	else:
		damage_enemy()

func _on_enemy_died():
	timer.stop()
	animation_player.play("Expire")
	await animation_player.animation_finished
	queue_free()

func damage_enemy():
	enemy.health -= damage
