extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var arrows = $Arrows
@onready var arrow_preload = preload("res://scenes/units/archers/arrow.tscn")

enum {
	IDLE,
	ATTACK,
	COOLDOWN
}

var enemies = []
var state:
	set(value):
		state = value
		match state:
			IDLE: 
				idle_state()
			ATTACK: 
				attack_state()
			COOLDOWN:
				cooldown_state()

func _ready():
	state = IDLE

func idle_state():
	animation_player.play("D_Idle")

func attack_state():
	animation_player.play("D_Attack")

func cooldown_state():
	animation_player.play("D_Preattack")
	await animation_player.animation_finished
	if len(enemies) >= 1:
		state = ATTACK
	else:
		state = IDLE

func shoot():
	if len(enemies) > 0:
		var arrow = arrow_preload.instantiate()
		arrow.enemy = enemies[0]
		arrows.add_child(arrow)
	state = COOLDOWN

func _on_area_2d_body_entered(body):
	state = ATTACK
	enemies.append(body)

func _on_area_2d_body_exited(body):
	enemies.erase(body)
