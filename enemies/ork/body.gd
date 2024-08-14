extends CharacterBody2D

const SPEED = 0.03

enum {
	WALK,
	ATTACK,
	DEATH
}

@onready var animation_player = $AnimationPlayer
@onready var ork = $".."

@onready var target = get_parent().get_parent().get_parent().get_parent()

var state:
	set(value):
		state = value
		match state:
			ATTACK: attack_state()
			DEATH: death_state()
var health = 1000:
	set(value):
		health = value
		if health <= 0:
			state = DEATH

var damage = 10
var direction: String: # The value is given by the path: Up (U), Right (R), Down (D) or Left (L)
	set(value):
		direction = value
		# If direction is changed, update the animation
		match state:
			WALK: walk_state()
			ATTACK: attack_state()
			DEATH: death_state()

func walk_state():
	animation_player.play(str(direction, "_Walk"))

func attack_state():
	animation_player.play(str(direction, "_Attack"))
	ork.set_process(false)

func hit():
	target.health -= damage

func death_state():
	animation_player.play(str(direction, "_Death"))
	ork.set_process(false)
	await animation_player.animation_finished
	
	Signals.emit_signal("target_die", self)
	ork.queue_free()
