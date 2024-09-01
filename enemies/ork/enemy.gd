extends CharacterBody2D

const SPEED = 0.03

enum States {
	WALK,
	ATTACK,
	DEATH
}

@onready var animation_player = $AnimationPlayer
@onready var ork = $".."
@onready var collision_shape_2d = $CollisionShape2D

var target
var state:
	set(value):
		state = value
		match state:
			States.ATTACK: attack_state()
			States.DEATH: death_state()
var direction: String: # The value is given by the path: Up (U), Right (R), Down (D) or Left (L)
	set(value):
		direction = value
		# If direction is changed, update the animation
		walk_state()
var health = 50:
	set(value):
		health = value
		if health <= 0:
			state = States.DEATH
var damage = 10
var reward = 50

func walk_state():
	animation_player.play(str(direction, "_Walk"))

func attack_state():
	animation_player.play(str(direction, "_Attack"))
	ork.set_process(false)

func hit():
	target.health -= damage

func death_state():
	Signals.emit_signal("target_die", self)
	collision_shape_2d.set_deferred("disabled", true)
	PlayerStats.money += reward
	ork.set_process(false)
	animation_player.play(str(direction, "_Death"))
	await animation_player.animation_finished
	ork.queue_free()

func _on_area_2d_body_entered(body):
	target = body
	state = States.ATTACK
