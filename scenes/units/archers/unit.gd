extends Node2D
@onready var animation_player = $AnimationPlayer
enum {
	IDLE,
	CHASE
}
var state:
	set(value):
		state = value
		match state:
			IDLE: 
				idle_state()
			CHASE: 
				chase_state()

func _ready():
	state = IDLE

func idle_state():
	print(true)
	animation_player.play("D_Idle")
	await get_tree().create_timer(3.0).timeout
	state = CHASE

func chase_state():
	animation_player.play("D_Preattack")
