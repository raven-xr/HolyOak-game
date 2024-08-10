extends CharacterBody2D

const SPEED = 0.1

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var target_health = get_parent().get_parent().health

var health = 100:
	set(value):
		health = value
		if health <= 0:
			death()
var damage = 10
var direction: String = "D" # The value is given by the path: Up (U), Right (R), Down (D) or Left (L)

func walk():
	animation_player.play(str(direction, "_Walk"))

func attack():
	animation_player.play(str(direction, "_Attack"))

func hit():
	target_health -= damage

func death():
	animation_player.play(str(direction, "_Death"))
	await animation_player.animation_finished
	Signals.emit_signal("target_die", self)
	queue_free()
