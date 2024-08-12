extends CharacterBody2D

const SPEED = 0.03

@onready var animation_player = $AnimationPlayer
@onready var ork = $".."

@onready var target = get_parent().get_parent().get_parent().get_parent()

var health = 1000:
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
	target.health -= damage

func death():
	animation_player.play(str(direction, "_Death"))
	ork.set_process(false)
	await animation_player.animation_finished
	
	Signals.emit_signal("target_die", self)
	ork.queue_free()
