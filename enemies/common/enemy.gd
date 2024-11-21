extends CharacterBody2D

enum States {
	WALK,
	ATTACK,
	DEATH
}

@onready var death = $SFX/Death
@onready var path_follow_2d = $".."
@onready var hit_sfx = $SFX/Hit
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

@onready var stats: Dictionary = EnemyData.get(name.to_upper())
@onready var health: int = stats["health"]:
	set(value):
		health = value
		if health <= 0:
			state = States.DEATH
@onready var damage: int = stats["damage"]
@onready var reward: int = stats["reward"]

var direction: String: # The value is being given by the path: Up (U), Right (R), Down (D) or Left (L)
	set(value):
		direction = value
		animation_player.play(value + "_Walk")
var state: int:
	set(value):
		state = value
		match state:
			States.WALK: walk_state()
			States.ATTACK: attack_state()
			States.DEATH: death_state()

signal moved()

func _ready():
	state = States.WALK

func _process(_delta):
	moved.emit(global_position)

func walk_state():
	path_follow_2d.speed = stats["speed"]

func attack_state():
	animation_player.play(str(direction, "_Attack"))
	path_follow_2d.set_process(false)

func hit():
	PlayerStats.health -= damage
	hit_sfx.play()

func death_state():
	death.play()
	Signals.emit_signal("target_died", self)
	collision_shape_2d.set_deferred("disabled", true)
	PlayerStats.money += reward
	path_follow_2d.set_process(false)
	animation_player.play(str(direction, "_Death"))
	await animation_player.animation_finished
	path_follow_2d.queue_free()
